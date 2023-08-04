***WIP - work machine setup script

Very uninteresting (for now) boredom project for automating the steps I perform when setting up 
a new work machine. 

****Why?
- my work prohibits backing up to external media (Time Machine, cloud options, etc)
- working in IT, I find myself wanting to nuke this computer from orbit every so often (I really 
should use VMs for testing more often)
- I got bored on the train to work and decided to start plugging away at a script to automate 
some of the boring stuff

**** TO-DO's and acceptance criteria
Ideally, this should performm the following:
- install apps not configured through company MDM
- configure preferences (dotfiles) for these apps as much as possible
- configure aesthetic defaults and OS-level preferences (macOS defaults list, Dock arrangement, 
custom wallpapers

**** Usage
- Currently, just ... run the thing. 
- Later, things should be omittable by running ./setup_scrip.sh --skip [ARGS] or similar
