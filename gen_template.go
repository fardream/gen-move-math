package main

import (
	"bytes"
	"text/template"
)

// GenText generates text from the the given template and data.
// name is the name of the template.
func GenText(name, templateText string, s any) (string, error) {
	tmpl, err := template.New(name).Parse(templateText)
	if err != nil {
		return "", err
	}
	var buf bytes.Buffer
	err = tmpl.Execute(&buf, &s)
	if err != nil {
		return "", err
	}

	return buf.String(), nil
}
