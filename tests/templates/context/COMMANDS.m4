                                                                  context --result=OUTPUT_DIRECTORY`___'TEST_BASENAME  --once --luatex --nonstopmode TEST_FILENAME; rename 's/___/\//' OUTPUT_DIRECTORY`___'TEST_BASENAME*
# The `sed` part of the below command fixes some issues with the command `\read` in LuaMetaTeX, see also <https://mailman.ntg.nl/archives/list/ntg-context@ntg.nl/thread/FGYGH4PLUGMCEMFW65XXGBKPWWJTBT6G/>.
# TODO: Remove the `sed` part after this issue has been fixed.
sed -Ei -e ':a;N;$!ba;s/%\n *//g' -e 's/ +/ /g' keyval-setup.tex; context --result=OUTPUT_DIRECTORY`___'TEST_BASENAME  --once          --nonstopmode TEST_FILENAME; rename 's/___/\//' OUTPUT_DIRECTORY`___'TEST_BASENAME*
