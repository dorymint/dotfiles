func IsFile(path string) bool {
	if f, err := os.Stat(path); err == nil && !f.isDir() {
		return true
	}
	return false
}
