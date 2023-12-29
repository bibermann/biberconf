#!/usr/bin/env bash

alias git='LANGUAGE=en_US.UTF-8 git'

#**************************************************************
# auto completion for git aliases (see ~/.biberconf/gitconfig)
#**************************************************************

# Help:
#   If you have a git alias named `mycommand`,
#   then you would need to add here:
#
#   _git_mycommand()
#   {
#     __gitcomp_nl "$(__git_refs)"
#   }

_git_s()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_d()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_l()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_a()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_as()
{
  __gitcomp_nl "$(__git_refs)"
}
