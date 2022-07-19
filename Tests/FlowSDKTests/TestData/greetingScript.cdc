transaction(greeting: String) {
  execute { 
    log(greeting.concat(", World!")) 
  }
}