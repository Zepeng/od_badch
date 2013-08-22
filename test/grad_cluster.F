      subroutine grad_cluster(ios,pars,good_tubes,n_cluster,clusters,
     &             nhit_cl,nhit_for_cl,cl_hit)

      implicit none

*
* Larry Wai's PC 2 clustering algorithm, encapsulated
*     and generalized
*  K. Scholberg  Feb 1999

* Inputs:  
*        ios:  detector   ios=1: ID ios =2: OD
*        pars:  input parameters for hit selection
*           (note that meanings are different for ID and OD)
*  Output:
*   good_tubes: offsets of good tubes used for the clustering
*   n_cluster:  number of clusters 
*
*   clusters(icl,6), where icl is the cluster number
*  and for the other indices:  1,2,3 is x,y,z, 4 is time
*    and 5 is charge, 6 is max pmt charge in the cluster
*  This array is sorted by cluster charge.
*
*   nhit_cl(icl), for number of hits in the cluster
*  Again, sorted by cluster charge
*  
*   nhit_for_cl:  number of hits used for the clustering  
*   cl_hit(i_hit):  the cluster that each hit belongs to

#include "clust_params.h"
#include "cluster_info.h"
#include "cluster_hit.h"

c ios = 1 -> ID,  ios = 2 -> OD
      integer ios

c Input parameters
      integer num_pars
      parameter (num_pars = 4)
      real pars(num_pars)

c Number of bins for the clustering
      integer n_bin_inner,n_bin_outer
      parameter(n_bin_inner=21,n_bin_outer=11)
      integer numbin

c For center of charge calc

      real theta_coq,phi_coq
      real get_theta_coq
      external get_theta_coq
      real get_phi_coq
      external get_phi_coq

c Good tubes selected for the clustering
      integer good_tubes(n_hit_max)

c Select the hits to use for the clustering.  Info is loaded
c   in clusthit common  (n_hit,x_hit,y_hit,z_hit,t_hit,q_hit,q_tot)

c Always do OD hit selection (number of hits needed for coq calc for ID
c   clustering)

      call select_hits_od(pars,good_tubes)

c Get the center of charge coordinates

      if (n_hit.ge.1) then
         theta_coq=get_theta_coq(n_hit,q_hit,x_hit,y_hit,z_hit)
         phi_coq=get_phi_coq(n_hit,q_hit,x_hit,y_hit,z_hit,theta_coq)
      else
         theta_coq=0.
         phi_coq=0.
      endif

c      write(6,*)'theta,phi',theta_coq,phi_coq,n_hit

      if (ios.eq.1) then
         call select_hits_id(pars,good_tubes)
         numbin = n_bin_inner
      else
         numbin = n_bin_outer
      endif

c Now do the clustering 

      call do_cluster(numbin,theta_coq,phi_coq,n_cluster,
     &          clusters,nhit_cl,nhit_for_cl,cl_hit)

      return
      end


************************************************************

      subroutine select_hits_id(pars,good_tubes)

* Select ID hits.  Apply an overflow charge.
*  Inputs:  in pars array
*    q_overflow: overflow charge
*  Outputs:
*    x_hit,y_hit,z_hit,t_hit,q_hit in clusthit common

      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skpdst.h"
#include "skbadc.h"
#include "geopmt.h"

#include "clust_params.h"
#include "cluster_hit.h"


      integer num_pars
      parameter (num_pars = 4)
      real pars(num_pars)

      real q_overflow
      integer i_hit,hit_id     ! Hit indices

      integer good_tubes(n_hit_max)

      q_overflow = pars(1)


      call vzero(good_tubes,n_hit_max)
c Loop over hits

      do i_hit=1,nqisk
         hit_id=ihcab(i_hit)
         if (ibad(hit_id).lt.0.and.sk_geometry.eq.2) then
            q_hit(i_hit) = 0.
         else if (qisk(hit_id).ge.q_overflow) then
            q_hit(i_hit)=q_overflow
         else
            q_hit(i_hit)=qisk(hit_id)
         end if
         t_hit(i_hit)=tisk(hit_id)
         x_hit(i_hit)=xyzpm(1,hit_id)
         y_hit(i_hit)=xyzpm(2,hit_id)
         z_hit(i_hit)=xyzpm(3,hit_id)
         good_tubes(i_hit) = i_hit
      end do
        
      n_hit=nqisk
      
      return
      end


*************************************************

      subroutine select_hits_od(pars,good_tubes)

* Select OD hits.   Apply time and charge cuts
* Inputs:  in pars array
*   t_pmt_cut_window:  input to hitwin for time cut
*   q_pmt_anti_cut:  minimum charge cut
* Output:
*    x_hit,y_hit,z_hit,t_hit,q_hit in clusthit common

      implicit none

      integer num_pars
      parameter (num_pars = 4)
      real pars(num_pars)
      real t_pmt_cut_window, q_pmt_anti_cut, t_pmt_cut_min_default
      
c Output of hitwin
      real t_pmt_cut_min


#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skpdst.h"
#include "skbadc.h"
#include "geopma.h"

#include "clust_params.h"
#include "cluster_hit.h"
#include "skprint.h"

      integer good_tubes(n_hit_max)

      integer i_hit,hit_id     ! Hit indices
      integer i_hit_save

      real t_pmt_cut_min0 /800./   ! Fixed value for par(2)<0
      real t_pmt_cut_window0 /500./   ! Fixed value for par(2)<0

      integer good_od_hit
      external good_od_hit

c Hit selection parameters

      t_pmt_cut_window = pars(2)
      q_pmt_anti_cut = pars(3)
      t_pmt_cut_min_default = pars(4)

c Get the minimum time

      if (t_pmt_cut_window.gt.0) then
         call hitwin(t_pmt_cut_min,t_pmt_cut_window,q_pmt_anti_cut,
     &                    t_pmt_cut_min_default)
      else
         t_pmt_cut_min = t_pmt_cut_min0
         t_pmt_cut_window = t_pmt_cut_window0
      endif

c      write(6,*)'select_hits_od: ',t_pmt_cut_min

      i_hit_save=0
      do i_hit=1,nhitaz /* number of hits in the outer detector */
         hit_id=icabaz(i_hit)
         if   ((good_od_hit(i_hit).ne.0)
     &        .and. ( qaskz(i_hit) .gt. q_pmt_anti_cut ) 
     &        ) then

            if (( taskz(i_hit) .gt. t_pmt_cut_min  )
     &           .and.( taskz(i_hit) .lt. 
     &           t_pmt_cut_min+t_pmt_cut_window  )) then

c Check on good OD tube number (KS April 7 1999)
               hit_id=hit_id-20000
               if (hit_id.gt.0.and.hit_id.le.MAXPMA) then


                  i_hit_save=i_hit_save+1
                  good_tubes(i_hit_save) = i_hit

                  q_hit(i_hit_save)=qaskz(i_hit)
                  t_hit(i_hit_save)=taskz(i_hit)
                  x_hit(i_hit_save)=xyzpma(1,hit_id)
                  y_hit(i_hit_save)=xyzpma(2,hit_id)
                  z_hit(i_hit_save)=xyzpma(3,hit_id)
                  if (
     &                 (abs(x_hit(i_hit_save)).gt.4000.).or.
     &                 (abs(y_hit(i_hit_save)).gt.4000.).or.
     &                 (abs(z_hit(i_hit_save)).gt.4000.)    ) then
                     if (skprint(pclib_io,1)) then

                        write(6,*)" crazy x:",x_hit(i_hit_save),
     &                    " y:",y_hit(i_hit_save),
     &                    " z:",z_hit(i_hit_save)
                     endif
                  end if
               end if   ! End of good tube check
            end if
         end if
      end do
      n_hit=i_hit_save
      return
      end



*************************************************************

      subroutine hitwin(t_pmt_cut_min,
     &  t_pmt_cut_window,q_pmt_anti_cut,t_pmt_cut_min_default)

*  Get the hitsum window 

*   Input: 
*       t_pmt_cut_window:  window to count hits in
*       q_pmt_anti_cut:  charge threshold for tubes to include
*       t_pmt_cut_min_default:  default time for start of time window,
*              used if there are no time mins with the minimum number of hits
*   Output:  t_pmt_cut_min:  start of time window

      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skpdst.h"
#include "skbadc.h"
#include "hitwinpar.h"

      real t_pmt_cut_min,t_pmt_cut_window,t_pmt_cut_min_default
      real q_pmt_anti_cut
      integer i_hit,hit_id
      integer i_hitsum_window,j_hitsum_window,
     &              hitsum_window(0:3200),hitsum_window_max
      integer good_od_hit
      external good_od_hit
 
      integer min_in_bin_default /6/
      real hitwin_start_default /-16000./
      real hitwin_end_default /16000./
     

c Set defaults

      if (hitwin_start.eq.0..and.hitwin_end.eq.0.) then
         min_in_bin = min_in_bin_default
         hitwin_start = hitwin_start_default
         hitwin_end = hitwin_end_default
      endif

c  Find OD maximum hit window

      do i_hitsum_window=0,3200
         hitsum_window(i_hitsum_window)=0
      end do
      do i_hit=1,nhitaz
         hit_id=icabaz(i_hit)
         if   ((good_od_hit(i_hit).ne.0)
     &        .and. ( qaskz(i_hit) .gt. q_pmt_anti_cut ) 
     &        .and. ( taskz(i_hit) .gt. hitwin_start )
     &        .and. ( taskz(i_hit) .lt. hitwin_end )
     &        ) then
            i_hitsum_window=min(int(taskz(i_hit)/10.+1600.),
     &               3200-int(t_pmt_cut_window/10.))
            do j_hitsum_window=i_hitsum_window,
     &                i_hitsum_window+int(t_pmt_cut_window/10.)
               hitsum_window(j_hitsum_window)=
     &                hitsum_window(j_hitsum_window)+1
            end do
         end if
      end do

      hitsum_window_max = min_in_bin
      t_pmt_cut_min = t_pmt_cut_min_default
      do i_hitsum_window=0,3200
         if (hitsum_window(i_hitsum_window).gt.hitsum_window_max) then
            hitsum_window_max=hitsum_window(i_hitsum_window)
            t_pmt_cut_min=(float(i_hitsum_window)-1600.)*10.
     &                 - t_pmt_cut_window
         end if
      end do

      return
      end

***********************************************************

      subroutine do_cluster(numbin,theta_coq,phi_coq,n_cluster,
     &          clusters,nhit_cl,nhit_for_cl,cl_hit)

* Fill angular bins for the clustering
* Inputs:
*  numbins:  number of bins
*  theta_coq, phi_coq:  coordinates of the center of charge

* Outputs:
*   n_cluster:  number of clusters 
*
*   clusters(icl,6), where icl is the cluster number
*  and for the other indices:  1,2,3 is x,y,z, 4 is time
*    and 5 is charge, 6 is max pmt charge in the cluster
*  This array is sorted by cluster charge.
*
*   nhit_cl(icl), for number of hits in the cluster
*  Again, sorted by cluster charge
*
*   nhit_for_cl:  number of hits used for the clustering  
*   cl_hit(i_hit):  the cluster that each hit belongs to

      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skpdst.h"
#include "skbadc.h"
#include "skprint.h"
#include "clust_params.h"
#include "cluster_info.h"
#include "cluster_hit.h"

      integer numbin
      real theta_coq,phi_coq

      integer i_coord

      integer n_bin_max
      parameter (n_bin_max =441)

c Grid variables 

      integer nhit_grid(n_bin_max)
      real q_grid(n_bin_max),qqh_grid(n_bin_max)
      real xqh_grid(n_bin_max),yqh_grid(n_bin_max),zqh_grid(n_bin_max),
     &                       tqh_grid(n_bin_max)
      integer gr_hit(n_hit_max)

      integer cluster(n_bin_max)
      integer g_grid(n_bin_max)

      integer i_hit,i_loop,i_next

c For sorting clusters
      integer indices(n_cluster_max)


      integer get_grid_coord
      external get_grid_coord

      integer get_gradient
      external get_gradient

c Cluster variables

      real q_cluster(n_cluster_max)
      real qqh_cluster(n_cluster_max)
      real xqh_cluster(n_cluster_max)
      real yqh_cluster(n_cluster_max)
      real zqh_cluster(n_cluster_max)
      real tqh_cluster(n_cluster_max)
      integer  nhit_cluster(n_cluster_max)

      integer icl,jcl

c Zero grid summation variables 

      do i_coord=1,numbin**2
         q_grid(i_coord)=0.
         nhit_grid(i_coord)=0
         qqh_grid(i_coord)=-9999.
         tqh_grid(i_coord)=-666.
      end do
         
c Fill angular bins with hit data

      do i_hit=1,n_hit
            
         i_coord=get_grid_coord(x_hit(i_hit),y_hit(i_hit),
     &           z_hit(i_hit),theta_coq,phi_coq,numbin)
         if ((i_coord.lt.1).or.(i_coord.gt.numbin**2)) then
            if (skprint(pclib_io,1)) then
               write(6,*)'invalid grid coord: ',i_coord,'theta: ',
     &              theta_coq,' phi: ',phi_coq
            endif
         end if
         gr_hit(i_hit)=i_coord
         q_grid(i_coord)=q_grid(i_coord)+q_hit(i_hit)
         nhit_grid(i_coord)=nhit_grid(i_coord)+1
         if (q_hit(i_hit).gt.qqh_grid(i_coord)) then
            qqh_grid(i_coord)=q_hit(i_hit)
            tqh_grid(i_coord)=t_hit(i_hit)
            xqh_grid(i_coord)=x_hit(i_hit)
            yqh_grid(i_coord)=y_hit(i_hit)
            zqh_grid(i_coord)=z_hit(i_hit)
         end if
      end do

c Find charge gradient and number of local maxima.

      n_cluster = 0

c      write(6,*)'numbin: ',numbin,theta_coq,phi_coq

      do i_coord=1,numbin**2
         if (q_grid(i_coord).eq.0) then 
            g_grid(i_coord)=-1
         else
            g_grid(i_coord)=get_gradient(i_coord,q_grid,numbin)
            if ((g_grid(i_coord).eq.-1).or.
     &               (g_grid(i_coord).gt.numbin**2)) then
               if (skprint(pclib_io,1)) then
                  write(6,*)"Invalid gradient: ",g_grid(i_coord),
     &                " coord: ",i_coord
               endif
            end if
         end if


         if (i_coord.eq.g_grid(i_coord)) then
            n_cluster = n_cluster + 1
            cluster(i_coord)=n_cluster
         else
            cluster(i_coord)=-1
         end if

      end do

c Find clusters on angular grid 

      do i_coord=1,numbin**2
         if (q_grid(i_coord).ne.0.) then
            if (i_coord.ne.g_grid(i_coord)) then
               i_next=i_coord
               i_loop=0
 666           i_next=g_grid(i_next)
               if (i_next.eq.-1) then
                  if (skprint(pclib_io,1)) then

                     write(6,*)'invalid grid coord'
                     write(6,*)'==> i_coord=',i_coord,
     &                    'q_grid(i_coord)=',q_grid(i_coord)
                     write(6,*)'==> i_next =',i_next,
     &                    'q_grid(i_next)=',q_grid(i_next)
                  endif
                  i_loop=100
               end if
               i_loop=i_loop+1
               if ((cluster(i_next).eq.-1).and.(i_loop.lt.100)) goto 666
               cluster(i_coord)=cluster(i_next)
            end if
         end if
      end do

c Zero cluster quantities

      do icl = 1,n_cluster_max
         q_cluster(icl)  = 0.
         qqh_cluster(icl)  = 0.
         nhit_cluster(icl) = 0
         xqh_cluster(icl)  = 0.
         yqh_cluster(icl)  = 0.
         zqh_cluster(icl)  = 0.
         tqh_cluster(icl)  = 0.
      enddo
         
c Sum cluster quantities 
      do i_coord=1,numbin**2
         if (cluster(i_coord).gt.n_cluster) then
            if (skprint(pclib_io,1)) then
              write(6,*)'invalid cluster number:',cluster(i_coord)
           endif
         else
            if (cluster(i_coord).ne.-1) then
               q_cluster(cluster(i_coord))=
     &              q_cluster(cluster(i_coord))+q_grid(i_coord)
               nhit_cluster(cluster(i_coord))=
     &              nhit_cluster(cluster(i_coord))+nhit_grid(i_coord)
               if (qqh_grid(i_coord)
     &              .gt.qqh_cluster(cluster(i_coord))) then
                  qqh_cluster(cluster(i_coord))=qqh_grid(i_coord)
                  tqh_cluster(cluster(i_coord))=tqh_grid(i_coord)
                  xqh_cluster(cluster(i_coord))=xqh_grid(i_coord)
                  yqh_cluster(cluster(i_coord))=yqh_grid(i_coord)
                  zqh_cluster(cluster(i_coord))=zqh_grid(i_coord)
               end if
            end if
         end if
      end do   ! End of cluster sum

* Now sort by max summed charge

      call sortzv(q_cluster(1),indices,n_cluster,1,1,0)

c Zero output arrays

      do icl = 1,n_cluster_max
        
         do jcl = 1,6
            clusters(icl,jcl) = 0.
         enddo
         nhit_cl(icl) = 0

      enddo


c Arrange output

      do icl = 1,n_cluster
        
         clusters(icl,1) = xqh_cluster(indices(icl))
         clusters(icl,2) = yqh_cluster(indices(icl))
         clusters(icl,3) = zqh_cluster(indices(icl))
         clusters(icl,4) = tqh_cluster(indices(icl))
* Note this is summed charge
         clusters(icl,5) = q_cluster(indices(icl))
* And this is maximum charge
         clusters(icl,6) = qqh_cluster(indices(icl))

         nhit_cl(icl) = nhit_cluster(indices(icl))

      enddo


c Zero out cl_hit array

      call vzero(cl_hit,n_hit_max)

c Get cluster info for hits (sorted cluster numbers)

      nhit_for_cl = n_hit

      do i_hit=1,n_hit
         i_coord=gr_hit(i_hit)
c Find the old cluster number
         do icl = 1,n_cluster
           if (cluster(i_coord).eq.indices(icl)
     &                 .and.cluster(i_coord).ne.-1) then
             cl_hit(i_hit)=icl
          endif
         enddo
      end do
      return
      end


***********************************************************
      integer function good_od_hit(i_hit)

* Return 1 if good OD hit, 0 if bad

      implicit none

#include "skparm.h"
#include "skhead.h"
#include "sktq.h"
#include "skbadc.h"
C#include "nework.h"

      integer hit_id,i_hit

      good_od_hit = 1

      hit_id = icabaz(i_hit)

* Non-MC event
      if (mdrnsk.ne.0 .and. mdrnsk.ne.999999 ) then
         if ((hit_id.eq.-1).or.
     &        (ibada(hit_id-20000).ne.0).or.
     &        (btest(ihtflz(i_hit),15)).or. ! ofl reject flag 
     &        (.not.btest(ihtflz(i_hit),3).and. sk_geometry.le.3).or.
     &        ((iand(ihtflz(i_hit),1).ne.1.)  .and. sk_geometry.ge.4)) ! no global trig bit
     &        then  

* Hit is bad
            good_od_hit = 0
         endif

* MC event
      else
         if ((hit_id.eq.-1) .or.
     &       (ibada(hit_id-20000)).ne.0 .or.
     &       ((iand(ihtflz(i_hit),1).ne.1.)  .and. sk_geometry.ge.4) ) then
            good_od_hit = 0
         endif
      endif

      return 
         
      end
