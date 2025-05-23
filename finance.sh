#!/bin/bash

wages_from_annual() {
  if [[ ! "$1" ]]; then
    read -p "Enter annual wage: " a
    if [[ $a ]]; then
      annual=$a
    fi
  else
    a="$1"
  fi
  get_monthly_from_annual $a
  get_biweekly_from_annual $a
  get_weekly_from_annual $a
  get_hourly_from_annual $a
}

get_monthly_from_annual() {
  monthly_from_annual="$(echo "$1 / 12" | bc)"
  echo "Monthly ~= \$$monthly_from_annual"
}

get_biweekly_from_annual() {
  biweekly_from_annual="$(echo "$1 / 26" | bc)"
  echo "Bi-weekly ~= \$$biweekly_from_annual"
}

get_weekly_from_annual() {
  weekly_from_annual="$(echo "$1 / 52" | bc)"
  echo "Weekly ~= \$$weekly_from_annual"
}

get_hourly_from_annual() {
  hourly_from_annual="$(echo "scale=2; $1 / 52 / 40" | bc)"
  echo "Hourly ~= \$$hourly_from_annual"
}

overtime() {
  wage="$1"
  if [[ "$2" ]]; then
    hours="$2"
  else
    hours=60
  fi
  overtime_hours=$((hours - 40))
  overtime_calculation="$(echo "scale=2; $wage * 40 + $wage * 1.5 * $overtime_hours" | bc)"
  echo "Overtime for \$$wage an hour at $hours hours a week = $overtime_calculation"
}

hours_per_day_per_week() { #40 8 5; (hours per week, hours per day, days per week)
  hours_per_week="$1"
  hours_per_day="$2"
  days_per_week="$3"
  if [[ ! $1 =~ [0-9] ]]; then
    hours_per_week="$(echo "scale=2; $hours_per_day * $days_per_week" | bc)"
    echo "Working $hours_per_day hours a day for $days_per_week days per week means you're working $hours_per_week hours per week"
  elif [[ ! $2 =~ [0-9] ]]; then
    hours_per_day="$(echo "scale=2; $hours_per_week / $days_per_week" | bc)"
    echo "Working for $hours_per_week hours a week for $days_per_week days per week means you must work $hours_per_day hours per day"
  elif [[ ! $3 =~ [0-9] ]]; then
    days_per_week="$(echo "scale=2; $hours_per_week / $hours_per_day" | bc)"
    echo "Working for $hours_per_week hours a week for $hours_per_day hours per day means you must work $days_per_week days per week"
  fi
}

math_bash() {
  echo "scale=2; $@" | bc
}

budget() {
  read -n1 -p "(a)dd to budget, (d)elete from budget, (l)ist budget)"
}
