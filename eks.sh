eksctl create cluster --name=madhu1cluster \
--region=us-east-1 \
--zones=us-east-1a,us-east-1b \
--without-nodegroup

 eksctl create nodegroup \
  --cluster madhu1cluster \
  --region us-east-1 \
  --name my-mng \
  --node-ami-family ami-family \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 2 \
  --nodes-max 4 \
  --node-volume-size=20 \
  --ssh-access \
  --ssh-public-key jenkins
  --managed \
  --asg-access \
  --external-dns-access \
  --full-ecr-access \
  --appmesh-access \
  --alb-ingress-access