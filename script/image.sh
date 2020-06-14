# set required envs
PROJECT_NAME=manage-words
IMAGE_NAME=goyalmunish/${PROJECT_NAME}

# building and pushing iamge
echo "STEP-01: Building ${PROJECT_NAME} image..."
docker build -t ${IMAGE_NAME} -f Dockerfile ./
echo "STEP-02: Pushing ${PROJECT_NAME} image..."
docker push ${IMAGE_NAME}:latest
echo "STEP-03: Pulling ${PROJECT_NAME} image..."
docker pull ${IMAGE_NAME}:latest

# running the image in production/development environment
if [[ $RAILS_ENV == "production" ]]; then
  echo "STEP-04: Running ${PROJECT_NAME} image in production environment..."
  docker rm -f ${PROJECT_NAME}
  docker run -it -d --name ${PROJECT_NAME} -e PS_START=de-$(uname -n) -e HOST_PLATFORM=$(uname -s) -p 3000:3000 ${IMAGE_NAME}
elif [[ $RAILS_ENV == "development" ]]; then
  echo "STEP-04: Running ${PROJECT_NAME} image in development environment..."
  docker rm -f ${PROJECT_NAME}
  docker run -it -d --name ${PROJECT_NAME} -e PS_START=de-$(uname -n) -e HOST_PLATFORM=$(uname -s) -p 3000:3000 -v $(pwd):/root/${PROJECT_NAME} ${IMAGE_NAME} /bin/bash -c "ping -i 0.2 $(gateway_ip)"
else
  echo "STEP-04: Skipped running ${PROJECT_NAME} image."
fi
