      subroutine odpc_2nd_s(nhit_pc_2nd)

* K. Scholberg May 99
* Rewrite to use new clustering interface

      implicit none


#include "clust_params.h"
#include "od_clusters.h"
#include "hitwinpar.h"

      real pars(4)
      integer good_od_tubes(n_hit_max)
      integer nhit_pc_2nd

      integer n_od_cluster
      real od_clusters(n_cluster_max,6)
      integer nhit_cl_od(n_cluster_max)
      integer nhit_for_cl_od
      integer cl_hit_od(n_hit_max)

c Set hitwin parameters (these are the default)
      min_in_bin = 6
      hitwin_start = -16000.
      hitwin_end = 16000.

      pars(1) = 0.    ! q_overflow, not needed for OD-only clustering
      pars(2) = -1    ! Don't use hitwin; take default value
      pars(3) = 0.    ! q_pmt_anti_cut
      pars(4) = 0.    ! t_pmt_cut_min_default

c Run OD clustering routine
 
      call grad_cluster(2,pars,good_od_tubes,n_od_cluster,od_clusters,
     &             nhit_cl_od,nhit_for_cl_od,cl_hit_od)


      if (n_od_cluster.ge.1) then
         nhit_pc_2nd = nhit_cl_od(1)
      else
         nhit_pc_2nd = 0
      endif

      x_outer = od_clusters(1,1)
      y_outer = od_clusters(1,2)
      z_outer = od_clusters(1,3)

      return
      end

      

