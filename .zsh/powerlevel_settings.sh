# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
else
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator dir vcs)
fi
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs disk_usage)
POWERLEVEL9K_MODE='nerdfont-complete'
