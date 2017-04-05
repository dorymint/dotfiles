func echo() string {
	for sc := bufio.NewScanner(os.Stdin); sc.Scan(); {
		if sc.Err() != nil {
			log.Fatalf("echo(): %v", sc.Err())
		}
		return sc.Text()
	}
}
