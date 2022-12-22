<div align="center">
  <p></p>
  <h1>Battagel's Dockerised Development Environment</h1>
  <p></p>
  <p align="center">
    <a href="#-intro"><b>Intro</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#prerequisites-"><b>Prerequisites</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#installation-"><b>Installation</b></a>
  </p>
  <br />
</div>

## Intro
Customising your development environment on multiple systems is a real faff isn't it! Fortunately there is a great solution, Dockerise it! The following is a Docker image comprised of all my dotfiles preinstalled and configured ready for development. Simply run the "dev" alias and the container will run mounting the current directory.

## Prerequisites
1. Docker installed and running
2. Access to [deb.debian.org](deb.debian.org)

## Installation
Clone the repo. Enter into the repo and run the following:
```
docker build -t dev-env .
```
Add an alias to .zshrc or .bashrc for starting the dev env.
```
echo "alias dev='docker run --rm -ti -v "${PWD}":/home/dev/"${PWD##*/}" dev-env'" >> ~/.zshrc
source .zshrc
```
Run the dev_env container with:
```
$  dev
```
