# Scripts

This folder will contain useful scripts to somehow automate suitable tasks in the 
IO2 Toolbox creation effort.

Right now I can foresee the automatic creation of issues that can be assigned
and labelled semi-automatically... We'll see...

In order to do so, this is the initial approach to 'normalize' the original Excel 
file containing the Tools/Methodologies/...:

- It is first necessary to "freeze" the excel, to avoid that we overwrite anything. 
  The ideal approach would be to let the team edit, and let the script do all 
  the checking, but it would complicate it and, IMHO, I don't think it is worth it. 
  We can just tell people to stop modifying it from a given date and that if they have 
  aditional contributions, to write them down to later add them them "by hand".
- In the Tools tab:
  - We need to replace the values in the Type column with normalized values (we have to 
    agree on them).
  - I would suggest to replicate the Type column (up to 3 or 4) in case there are some 
    Tools that can belong to multiple types.
  - I would like to ask those who have added entries to also add something (if applicable) 
    in the comments column, and (this should be mandatory) the right value in the Platform 
    column
- In the Resources tab:
  - We have to replace the values in the Type column with values from the normalized ones 
    we decide.
  - The Colourbox license is missing
  - I would suggest to replicate the Type column (ut to 3 or 4) in case there are some 
    Resources that are multi-typed
- In the Methodologies tab:
  - I would like to discuss if we can also add a Methodology "type" (again up to 3-4 columns), 
   for which we would have to think about which ones to define. In fact, in the column 
   "Other comments" some people have written something that could be methodology


