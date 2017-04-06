package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func displayDaemon() chan<- string {
	ch := make(chan string)
	go func() {
		for {
			fmt.Println(<-ch)
		}
	}()
	return ch
}

func modifyDaemon(output chan<- string, prefix string) chan<- string {
	input := make(chan string)
	go func() {
		for {
			output <- fmt.Sprintf("%v:%v", prefix, <-input)
		}
	}()
	return input
}

// {Input > modify > Output}
func interactive() {
	outch := displayDaemon()
	ch := modifyDaemon(outch, "hello channel")

	for sc := bufio.NewScanner(os.Stdin); sc.Scan(); {
		if sc.Err() != nil {
			log.Fatalf("interactive:%v", sc.Err())
		}
		ch <- sc.Text()
	}
}

func main() {
	interactive()
}
