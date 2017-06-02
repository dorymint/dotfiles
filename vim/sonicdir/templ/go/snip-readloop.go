for sc := bufio.NewScanner(os.Stdin); sc.Scan(); {
	if sc.Err() != nil {
		// TODO: Countermove
		//log.Fatalf(":%v", sc.Err())
	}
	// TODO: sc.Text()
}

