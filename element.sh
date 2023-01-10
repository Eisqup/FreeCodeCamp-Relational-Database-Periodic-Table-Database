#! /bin/bash

# Check if argument is given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  # SQL initial
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # Call data from SQL
  # Check if argument in a digit number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$1")
  # Arugument is a string
  else
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1' OR name='$1'")
  fi

  # If atomic data not exist
  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database." 

  # Output message
  else
    echo $ELEMENT_DATA | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi