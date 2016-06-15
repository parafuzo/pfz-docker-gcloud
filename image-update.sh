#! /bin/bash

endnow() {
  echo "$1" && exit 1
}

echo "Git clone infra"
git clone https://$GITHUB_TOKEN@github.com/parafuzo/infra.git || endnow "Git clone fail."

DIR = "infra/$REPO_PATH"
echo "Moving to $DIR"
[ -d ${DIR}] && cd $DIR || endnow "\$DIR: $DIR does not exist."

echo "Remote info"
git remote -v

echo "Replace image to $IMAGE_NAME"
sed -i 's/image:.*/image: '$IMAGE_NAME'/g' deployment.yml || endnow "Fail to replace image name."

echo "Kube APPLY"
kubectl apply -f deployment.yml || endnow "Fail to apply deployment new image name"

git commit -am "New deployment image" || endnow "Fail to commit new image name"
git push || endnow "Fil to push new image name to repo"
