# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.
   - Always show prices in US dollars rounded to two decimal places.
   - When a question compares cities, include the city in the results and group by city.
   - Ignore listings with a missing (NULL) price when calculating averages or totals.
   - host_is_superhost and instant_bookable are stored as 't' or 'f'; translate them to Yes/No in answers.
   - Begin every answer with a one-sentence plain-English summary before showing the table or chart.
<!-- Add more rules below (Assignment 05 asks for at least three). Good candidates:
     `host_is_superhost` and `instant_bookable` are the text values 't' and 'f',
     not booleans; how to match a city name the user types; how to search `name`
     case-insensitively; and whether to ignore rows whose `review_scores_rating`
     is NULL when averaging ratings. -->
