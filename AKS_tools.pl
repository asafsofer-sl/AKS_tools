#!/usr/bin/env perl
#######################################################################################################################
#Script         : AKS_tools
#Usage          : ./AKS_tools 
#Purpose        : Various Config Validations,search,locate files etc..
#Prerequisites  : Files
#                       1. AKS_tools ( script )

# Contact	: Asaf.S
#######################################################################################################################

#Take date 
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time);
our $Date = sprintf("%.2d-%.2d-%.2d",$mon+1,$mday,$year+1900);
our $Time = sprintf("%.2d:%.2d:%.2d",$hour,$min,$sec);



print "\nSelect Action :\n \t 1. uptime-sla   \n\t 2. reconcile the cluster  \n\t 3. restart kube-dns pods \n\t 4. resart tunnel pods  \n\t 5. resart kube-proxy pods  \n\t 6. upgrade cluster   \n\t 7. get pods logs  \n\t 8. get kube-system pods  \n\t 9. describe node  \n\t 10. get nodes list \n\t 11. Show the details for a managed Kubernetes cluster \n\t 12. scale number of nodes up/down \n\t 13. create new nodepool \n\t 14. get nodepool names only \n\t 15. get nodepool list \n\n\t 0. exit\n";
print "\n--Your Choice :";
$act= <STDIN>;
chomp($act);


if($act eq 1) 
{ 
print "\n Uptime SLA is a tier to enable a financially backed, higher SLA for an AKS cluster. Clusters with Uptime SLA, also regarded as Paid tier in AKS REST APIs, come with greater amount of control plane resources and automatically scale to meet the load of your cluster. Uptime SLA guarantees 99.95% availability of the Kubernetes API server endpoint for clusters that use Availability Zones and 99.9% of availability for clusters that don't use Availability Zones. AKS uses master node replicas across update and fault domains to ensure SLA requirements are met. \n";	       
       	print "\nplease provide the subscriptions ID: \n";
                $sub= <STDIN>;
                chomp($sub);	
	        print "\nenable the uptime-sla \n";
                print "\nplease provide the resource group: \n";
		$rg= <STDIN>;
	        chomp($rg);
	        print "\nplease provide the clsuter name: \n";
	        $clus= <STDIN>;
	        chomp($clus);

                exec("az aks update --resource-group $rg --name $clus --uptime-sla");
                print "\n===========================reconsile the cluster below ============================\n";
	        print "\n az resource update --ids  /subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.ContainerService/managedClusters/$clus \n";


		}
       
if($act eq 2)
   {
       print "\n We reconcile the control plane & worker node pole with below command, the command below just doing PUT command with empty string and no impact on Production work  \n"; 
	print "\nplease provide the subscriptions ID: \n";
        $sub= <STDIN>;
        chomp($sub);
        print "\nplease provide the resource group: \n";
        $rg= <STDIN>;
        chomp($rg);
        print "\nplease provide the clsuter name: \n";
        $clus= <STDIN>;
        chomp($clus);
        print "\n===========================reconsile the cluster below ============================\n";
	print "\n az resource update --ids  /subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.ContainerService/managedClusters/$clus \n";

	print "\n\t 1. confirm to continue \n\t 0. exit\n";
	print "\n--Your Choice :"; $in= <STDIN>;chomp($in);
        if($in eq 1) { 

        exec("az resource update --ids  /subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.ContainerService/managedClusters/$clus");
}

      }


if($act eq 3) {

exec("kubectl delete po -l k8s-app=kube-dns -n kube-system");

}
if($act eq 4) {

	exec("kubectl delete po -l component=tunnel -n kube-system");

	}

if($act eq 5) {
exec("kubectl delete po -l component=kube-proxy -n kube-system"); 
}

if($act eq 6) {
print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);
   print "\nplease provide the target version need to upgrade to: \n";
   $KUBERNETES_VERSION=<STDIN>;
   chomp($KUBERNETES_VERSION);

print "\n\t 1. confirm to continue \n\t 0. exit\n";
        print "\n--Your Choice :"; $in= <STDIN>;chomp($in);
        if($in eq 1) {

exec("az aks upgrade --resource-group $myResourceGroup --name $myAKSCluster --kubernetes-version $KUBERNETES_VERSION");

}
}

if ($act eq 7) {

print "\nplease provide the pod name : \n";
        $pod= <STDIN>;
	chomp($pod);
print "\nplease provide the pod name space : \n";
 $ns= <STDIN>;
        chomp($ns);
exec("kubectl logs $pod -n $ns");	


}


if($act eq 8) {

print "\n------------ kube system :  ----------------------------------------------------\n";
exec("kubectl get pods -n kube-system");

       	
}

if($act eq 9) {

	print "\nplease provide node name : \n";
	$node=<STDIN>;
	chomp($node);
exec("kubectl describe node $node");
}

if($act eq 10) {

print "\n------------ Node List  :  ----------------------------------------------------\n";
exec("kubectl get nodes -o wide");

}
if($act eq 11) {

print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);

   print "\n\t 1. show output in CLI \n\t 2. extract output to Results.txt\n";
        print "\n--Your Choice :"; $in= <STDIN>;chomp($in);
        if($in eq 1) {

		exec("az aks show --resource-group $myResourceGroup --name $myAKSCluster")
	}
		else{

exec("az aks show --resource-group $myResourceGroup --name $myAKSCluster >> Results.txt")
}
}
if($act eq 12) {

   print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
   print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);
   print "\nplease provide number of nodes needed: \n";
   $index=<STDIN>;
   chomp($index);
   print "\nplease provide your node pool name: \n";
   $agentpool=<STDIN>;
   chomp($agentpool);

   exec("az aks scale --resource-group $myResourceGroup  --name $myAKSCluster --node-count $index --nodepool-name $agentpool")
   }
if($act eq 13) {
print "\n---please be aware that use nodepool will be created , and it is supported only with standard LB---\n";
 print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
   print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);
   print "\nplease provide number of nodes needed: \n";
   $index=<STDIN>;
   chomp($index);
   print "\nplease provide node new pool name: \n";
   $agentpool=<STDIN>;
   chomp($agentpool);
   exec("az aks nodepool add --resource-group $myResourceGroup --cluster-name $myAKSCluster --name $agentpool --node-count $index")
   }
if($act eq 14) {

print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);
   exec("az aks nodepool list --cluster-name $myAKSCluster --resource-group $myResourceGroup|grep name")
   }
if($act eq 15) {
print "\n---output will be save to file name: nodepool_list.txt---\n";
print "\nplease provide the resource group: \n";
   $myResourceGroup=<STDIN>;
   chomp($myResourceGroup);
print "\nplease provide the cluster name: \n";
   $myAKSCluster=<STDIN>;
   chomp($myAKSCluster);
   exec("az aks nodepool list --cluster-name $myAKSCluster --resource-group $myResourceGroup >> nodepool_list.txt")
   }


