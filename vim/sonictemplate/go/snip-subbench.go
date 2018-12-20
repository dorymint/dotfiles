b.Run("{{_input_:name}}", func(b *testing.B) {
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		{{_cursor_}}
	}
})
