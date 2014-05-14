gitlab-webhook-youtrack
=======================

Great Webhook for GitLab that executes commands, comments issues on Youtrack. Heroku compatible.

## Run

Prerequisites: ```npm install -g foreman coffee-script```

Install dependencies: ```npm install```

File example.env:
```
YOUTRACK_URL=http://youtrack.example.com
YOUTRACK_LOGIN=root
YOUTRACK_PASSWORD=password
```

Run: ```nf -e example.env start```

POST to ```http://your-host:5000/gitlab-youtrack```

## Commit message format

```Comment text #ID-1 New state Command```, where
* ```#ID-1``` – issue ID. If issue ID is detected on commit line, then this line is being parsed and executed. Issue ID's can be separated by colon to select multiple issues.
* ```Comment text``` – make comment "Comment text". Optional.
* ```New state``` – change issue state to "New state". Optional.
* ```Command``` – Execute command on selected issue. Optional.


Examples:
* ```made skeleton #ID-2 work 10m``` – comment and make work item),
* ```configured database #GH-10 Done``` – comment and change state,
* ```#TEST-1``` – just attach commit to issue,
* ```#TEST-2 Reopened```.
Multiline example (if commit is related to several issues differently):
```
refactored layouts #GH-10,#GH-15,#GH-16 Done work 10m
#GH-11 Won't fix
done by layouts #GH-10 Obsolete
```
