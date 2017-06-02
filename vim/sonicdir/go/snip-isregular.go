func IsRegular(fpath string) bool {
	info, err := os.Stat(fpath)
	if err != nil {
		return false
	}
	return info.Mode().IsRegular()
}
