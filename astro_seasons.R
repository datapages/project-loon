# data of equinoxes and solstices for 2013-2021
# https://data.giss.nasa.gov/modelE/ar5plots/srvernal.html
solar_events <- tibble::tribble(
  ~date,                  ~event,
  "2013-03-20 11:10 GMT", "vernal_equinox",
  "2014-03-20 16:59 GMT", "vernal_equinox",
  "2015-03-20 22:48 GMT", "vernal_equinox",
  "2016-03-20 04:37 GMT", "vernal_equinox",
  "2017-03-20 10:26 GMT", "vernal_equinox",
  "2018-03-20 16:16 GMT", "vernal_equinox",
  "2019-03-20 22:05 GMT", "vernal_equinox",
  "2020-03-20 03:54 GMT", "vernal_equinox",
  "2021-03-20 09:43 GMT", "vernal_equinox",
  "2013-06-21 05:09 GMT", "summer_solstice",
  "2014-06-21 10:57 GMT", "summer_solstice",
  "2015-06-21 16:46 GMT", "summer_solstice",
  "2016-06-20 22:34 GMT", "summer_solstice",
  "2017-06-21 04:22 GMT", "summer_solstice",
  "2018-06-21 10:10 GMT", "summer_solstice",
  "2019-06-21 15:58 GMT", "summer_solstice",
  "2020-06-20 21:46 GMT", "summer_solstice",
  "2021-06-21 03:34 GMT", "summer_solstice",
  "2013-09-22 20:49 GMT", "autumnal_equinox",
  "2014-09-23 02:38 GMT", "autumnal_equinox",
  "2015-09-23 08:27 GMT", "autumnal_equinox",
  "2016-09-22 14:15 GMT", "autumnal_equinox",
  "2017-09-22 20:04 GMT", "autumnal_equinox",
  "2018-09-23 01:53 GMT", "autumnal_equinox",
  "2019-09-23 07:41 GMT", "autumnal_equinox",
  "2020-09-22 13:30 GMT", "autumnal_equinox",
  "2021-09-22 19:19 GMT", "autumnal_equinox",
  "2013-12-21 17:13 GMT", "winter_solstice",
  "2014-12-21 23:03 GMT", "winter_solstice",
  "2015-12-22 04:53 GMT", "winter_solstice",
  "2016-12-21 10:42 GMT", "winter_solstice",
  "2017-12-21 16:32 GMT", "winter_solstice",
  "2018-12-21 22:22 GMT", "winter_solstice",
  "2019-12-22 04:11 GMT", "winter_solstice",
  "2020-12-21 10:01 GMT", "winter_solstice",
  "2021-12-21 15:51 GMT", "winter_solstice"
) |> dplyr::mutate(date = lubridate::ymd_hm(date))

# use solar events to determine start/end date of each season
seasons <- solar_events |>
  # sort in chronological order
  dplyr::arrange(date) |>
  dplyr::mutate(end = dplyr::lead(date), # season ends at next event
                season = event |> stringr::str_remove("_.*$") |>
                  forcats::fct_recode(spring = "vernal", fall = "autumnal") |>
                  as.character()) |> # convert event name to season name
  dplyr::select(season, start = date, end)

# given a segment start and end times, determine which season(s) it overlaps with
get_seasons <- \(segment_start, segment_end) {
  seasons |>
    # for each season, determine whether it overlaps
    dplyr::mutate(overlap = purrr::map2_lgl(start, end, \(season_start, season_end) {
      segment_start <= season_end & segment_end >= season_start
    })) |>
    # take only overlapping seasons
    dplyr::filter(overlap) |>
    dplyr::pull(season)
}
