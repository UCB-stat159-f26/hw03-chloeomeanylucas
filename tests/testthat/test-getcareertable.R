test_that("getcareertable works as expected", {
  women_name = "SerenaWilliams"
  expect_equal(colnames(getcareertable(women_name)), c("Date", "Player_Age", "Opponent_Age", "Age_Difference", "Player_Outcome"))
  expect_equal(length(unique(lapply(getcareertable(women_name), length))), 1) #all columns are equal length
  expect_equal(sum(is.na(getcareertable(women_name))), 0) #there should be no NA values
	
  men_name = "RodLaver"
  expect_equal(colnames(getcareertable(men_name)), c("Date", "Player_Age", "Opponent_Age", "Age_Difference", "Player_Outcome"))
  expect_equal(length(unique(lapply(getcareertable(men_name), length))), 1) #all columns are equal length
  expect_equal(sum(is.na(getcareertable(men_name))), 0) #there should be no NA values

  invalid_name = "JohnSmith"
  expect_error(getcareertable(invalid_name), c("Player or player data does not exist on Tennis Abstract. Make sure that the player's name is formatted as FirstLast in quotation marks"))
})