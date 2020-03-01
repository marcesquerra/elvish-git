
fn git [@git-args]{

  fn null_out [f]{
    { $f 2>&- > /dev/null }
  }

  fn has_failed [p]{
    eq (bool ?(null_out $p)) $false
  }

  try {


    if (eq $git-args [tree]) {
      e:git log --graph --decorate --pretty=oneline --abbrev-commit --all
    } elif (eq $git-args [log]) {
      e:git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset%n           %s%n           %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --abbrev=8
    } elif (eq $git-args [root]) {
      e:git rev-parse --show-toplevel
    } elif (eq $git-args [conflicts]) {
      e:git ls-files -u | cut -f 2 | sort -u
    } elif (eq $git-args [modified]) {
      e:git ls-files -m | cut -f 2 | sort -u
    } elif (eq $git-args [cd]) {
      cd (e:git rev-parse --show-toplevel)
    } elif (eq $git-args []) {
      e:git
    } else {
      h @rest = $@git-args
      if (and ( has-env KITTY_WINDOW_ID ) ( eq $h diff ) ) {

        if (not (has_failed { e:git diff $@rest }) ) {
          e:git -c difftool.kitty.cmd="kitty +kitten diff $LOCAL $REMOTE" -c diff.tool="kitty" difftool --no-symlinks --dir-diff $@rest 2> /dev/null
        } else {
          e:git diff $@rest
        }

      } elif (eq $h new) {
        branch @more = $@rest
        e:git checkout -b $branch
        e:git push --set-upstream origin $branch
      } else {
        e:git $h $@rest
      }
    }

  } except exception {
    fail "git failed"
  }
}
