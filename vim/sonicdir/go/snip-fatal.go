// str=func name
func fatal(str string, err error) {
	if err != nil {
		log.Fatalln(str, err)
	}
}

