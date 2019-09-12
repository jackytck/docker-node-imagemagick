workflow "Build workflow" {
  on = "push"
  resolves = ["push"]
}

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t docker-node-imagemagick ."
}

action "login" {
  uses = "actions/docker/login@master"
  needs = ["build"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "tag" {
  uses = "actions/docker/cli@master"
  needs = ["login"]
  args = "tag docker-node-imagemagick jackytck/docker-node-imagemagick:$(git describe --abbrev=0)"
}

action "push" {
  uses = "actions/docker/cli@master"
  needs = ["tag"]
  args = "push jackytck/docker-node-imagemagick:$(git describe --abbrev=0)"
}
