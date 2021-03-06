{
  # I don't like the default but my hand just types it
  ":q"="exit";
  vi="nvim";
  vim="nvim";
  top="btm";
  htop="btm";
  ytop="btm";
  cat="bat";

  # docker-compose;
  dc="docker-compose";
  dcu="docker-compose up --build";
  dcl="docker-compose logs -f";
  dcisolated="docker-compose up --build --no-deps consul_common common-redis common_db";

  # Navigation;
  ".."="cd ..";
  "..."="cd ../..";
  "...."="cd ../../..";
  "....."="cd ../../../..";

  # git;
  gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
  gc="git commit";
  gco="git checkout";
  gs="git status";
  gca="git commit --amend";
  gd="git diff";
  gdc="git diff --cached";
  gir="git rebase -i";
  gpr="gh pr create";
  gdpr="gh pr create --draft";
  gppr="git push origin HEAD && gh pr create --fill";
  gsur="git submodule update --remote";

  # Grep;
  grep="grep --color=auto";

  # json formatting;
  json="python3 -m json.tool";

  # Serve a folder
  servethis="python3 -m http.server";
}
