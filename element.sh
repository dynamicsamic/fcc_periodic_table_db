#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

MAIN() {
  # Parse argument
  if [[ -z "$1" ]]
  # If no argument provided exit with message.
  then
    echo "Please provide an element as an argument."
  else

    # If a number provided
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      VALUE=$1
      COLUMN='atomic_number'

    # If a single char provided
    elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
    then 
      VALUE="'$1'"
      COLUMN='symbol'

    # If a string provided
    elif [[ $1 =~ ^[A-Za-z]+$ ]]
    then
      VALUE="'$1'"
      COLUMN='name'
    else
      echo "Invalid option provided"
      exit      
    fi

    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, 
    type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $COLUMN = $VALUE;")
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT" | while IFS="|" read NUM SYM NAME MASS MELT BOIL TYPE
      do
        echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi

  fi
}

MAIN $1
