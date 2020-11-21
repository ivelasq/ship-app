# testing out calculations

# for the vessel selected, find the observation when it sailed the longest distance between two consecutive observations
# if there is a situation when a vessel moves exactly the same amount of meters, please select the most recent.  

library(geosphere)

ships <- read_csv(here::here("data", "ships.csv"))

ships_dist <-
  ships %>% 
  arrange(SHIPNAME, DATETIME) %>% 
  group_by(SHIPNAME) %>% 
  mutate(lon2 = lead(LON, 1),
         lat2 = lead(LAT, 1)) %>% 
  ungroup() %>% 
  mutate(dist = distHaversine(ships_dist[, c("LON", "LAT")], ships_dist[, c("lon2", "lat2")]))

ships_filtered <-
  ships_dist %>% 
  group_by(SHIPNAME) %>% 
  slice(which.max(dist)) %>% 
  slice(which.max(DATETIME))

write_rds(ships_filtered, here::here("data", "final", "ships_final.Rds"))
