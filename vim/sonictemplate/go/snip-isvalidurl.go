func isValidURL(rawurl string) bool {
	u, err := url.Parse(rawurl)
	if err != nil || u.Scheme == "" || u.Host == "" || u.Path == "" {
		return false
	}
	return true
}
