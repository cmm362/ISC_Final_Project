# General
**I recommend renaming your script file 'Final_Project_Code.R'.**

It is difficult to call and work with file names that have spaces in
them, especially in Linux. I would recommend separating words in a
file name with underscores or dashes.

It's also important to include
'.R' at the end of the filename, if you're writing R code (or '.py'
for Python code). This is because text editors use that extension to
figure out how to highlight code. When I opened the code in an editor
(I use emacs), it didn't do any text highlighting because it didn't
know that it was R code.

**Set up your folders in your git repository, rather than putting them
in Documents or a folder specific to your computer.**

You can add folders to your git repository by putting them in the
folder that is being added to github. For example, you can put a
"Data/" folder in the folder "ISC_Final_Project", or wherever you ran
the "git init" command. If you run "git add ." from the
"ISC_Final_Project" folder, it will then automatically add any files
in that folder, even if they are in the "Data/" subdirectory. If I
need to use the same data for multiple projects, I will put a copy of
the data in each repository that needs it. Unless your data takes up a
ton of space, this should be feasible. This means that the person
who is using your repository doesn't need to do any setup on their
machine in order for your code to work.

In general, I would avoid using absolute paths (for example,
'~/esander/Documents/mydata.txt') and instead use relative paths (for
example, './Data/mydata.txt'). Again, this means that the code can
work on someone else's machine. It's a good habit to get into, even if
you intend to be the only person using your code.
