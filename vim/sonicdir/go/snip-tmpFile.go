
// Create temp file, Return filename.
func tmpFile(content string) (string, error) {
	// use os temp directory
	f, err := ioutil.TempFile("", "prefix")
	if err != nil {
		log.Printf("tmpFile:%v", err)
		return "", err
	}
	defer func() {
		if errclose := f.Close(); errclose != nil {
			log.Printf("tempFile:%v", errclose)
		}
	}()
	_, err = f.WriteString(content)
	if err != nil {
		log.Printf("tmpFile:%v", err)
		return "", err
	}
	return f.Name(), nil
}

