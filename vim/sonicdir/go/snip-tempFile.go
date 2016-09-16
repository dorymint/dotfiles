
// Create tempfile, Return filename.
func tempFile(content string) (string, error) {
	// use os temp directory
	f, err := ioutil.TempFile("", "prefix")
	if err != nil {
		return "", err
	}
	defer func() {
		if errclose := f.Close(); errclose != nil {
			fmt.Fprintf(os.Stderr, "tempFile:%q\n", errclose)
		}
	}()
	_, err = f.WriteString(content)
	if err != nil {
		return "", err
	}
	return f.Name(), nil
}

