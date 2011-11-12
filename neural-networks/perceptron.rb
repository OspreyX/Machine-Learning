#!/usr/bin/ruby

def init_weights(number_inputs, max=1.0, min=-1.0)
  Array.new(number_inputs + 1) { min + ((max - min) * rand - max) }
end

def update_weights(weights, inputs, error, alpha)
  inputs.each_index do |i|
    weights[i] += alpha * error * inputs[i]
  end
  weights[-1] += alpha * error * 1.0 # update bias weight
end

def output(inputs, weights)
  sum = weights.last * 1.0 # start with bias 
  inputs.each_index do |i|
    sum += weights[i] * inputs[i]
  end
  (sum >= 0.0) ? 1.0 : 0.0
end

def train(set, weights, number_inputs, iterations, alpha)
  iterations.times do |count|
    errors = 0.0
    set.each do |input_set|
      inputs = input_set[0..-2] # ignore last element - is expected output
      expected = input_set.last # integer

      actual = output(inputs, weights)
      current_error = expected - actual
      errors += (current_error).abs
      update_weights(weights, inputs, current_error, alpha)
    end
    puts "Count: #{count} Errors: #{errors}"
  end
end

def test(set, weights, number_inputs)
  correct = 0
  set.each do |input_set|
    inputs = input_set[0..-2] # ignore last element - is expected output
    expected = input_set.last # integer

    actual = output(inputs, weights)
    correct += 1 if actual == expected
  end
  puts "Results: #{correct} correct out of #{set.size}"
end

def execute(set, number_inputs, iterations, alpha)
  weights = init_weights(number_inputs)
  train(set, weights, number_inputs, iterations, alpha)
  test(set, weights, number_inputs)
end

if __FILE__ == $0
  or_set = [ [0, 0, 0],
             [1, 0, 1],
             [0, 1, 1],
             [1, 1, 1] ]
  number_inputs = 2 
  iterations = 20
  alpha = 0.1

  execute(or_set, number_inputs, iterations, alpha)
end
