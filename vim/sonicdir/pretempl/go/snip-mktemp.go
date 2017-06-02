
// Create temp file, Return filename.
func mktemp(content string) (string, error) {
	// use os temp directory
	f, err := ioutil.TempFile("", "prefix")
	if err != nil {
		return "", err
	}
	defer f.Close()
	_, err = f.WriteString(content)
	if err != nil {
		return "", err
	}
	return f.Name(), nil
}

