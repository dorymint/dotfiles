func Benchmark{{_input_:name}}(b *testing.B) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		{{_cursor_}}
	}
}
