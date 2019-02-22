# QA Test API
API for QA candidates testing

## How it works

QA Test API is 

### POST#/users

```json
{
	"name": "QA Candidate", # name
	"cpf": "780.443.260-73", # CPF with dots (.) and dash (-) with verification digit
	"email": "candidate@wirecard.com", # email
	"birthday": "1990-01-01" # date in ISO 8601 format
}
```

Result:
HTTP Status 201 -> Created
HTTP Header Location -> ID of the created resource

## What it is been evaluated

- If candidate knows how to automate tests
- If candidate knows about API (we assume this kind of candidate knows screen Automation as well)
- Test cases: Good paths, Bad baths, how it is described, etc...
- If candidate finds easy bugs
- If candidate finds hard bugs
- How candidate reports bugs

## Proposital Bugs

We inserted some bugs that we hope the candidate may find:

1. (Easy level) When an invalid CPF is taken, API returns HTTP Status 500
2. (Easy level) API accepts email with invalid format (not name@domain.com)
2. (Medium level) Birthdate allows future dates
4. (Hard level) Intermittent bug: in 1 of 5 command of Post#/users returns HTTP API 500 for no reason