#! /bin/bash
echo "Git clone infra"
git clone https://$GITHUB_TOKEN@github.com/parafuzo/infra.git

echo "Remote info"
git remote -v

echo "Moving to infra/$REPO_PATH"
cd infra/$REPO_PATH

echo "Replace image to $IMAGE_NAME"
sed -i -e 's/image:.*/image: '$IMAGE_NAME'/g' deployment.yml

echo "Kube APPLY"
kubectl apply -f deployment.yml

git commit -am "New deployment image"
git push
