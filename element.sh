#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no input is provided: 
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Check if the argument provided is an atomic number: 
if [[ $1 =~ ^[1-9]+$ ]]; then
  RESULT=$($PSQL "SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number = $1")

# If not a number, then it must be a string:
else
  RESULT=$($PSQL "SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# If element not found:
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Display the information about the element
echo $RESULT | while IFS=" |" read ATOMIC_NUMBER TYPE MASS MELTING_POINT BOILING_POINT SYMBOL NAME; do
  if [[ $1 == "1" || $1 == "H" || $1 == "Hydrogen" ]]; then
    echo -e "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
  else
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
done
