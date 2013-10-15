# secmarketstructure

The `secmarketstructure` package allows to easily download the [SEC Market Structure data](http://www.sec.gov/marketstructure/) and load it in R.

It is currently in an early beta version, but should work nonetheless. Comments and suggestions are however very welcome.

## Installation

The `secmarketstructure` package is hosted on Github and the simplest way to install it is therefore to use the `devtools` package.

Install the `devtools` package if you do not have it yet:

    install.packages("devtools")
    
Then load `devtools` and install `secmarketstructure` from Github.

    library(devtools)
    install_github("secmarketstructure", username = "fcocquemas")

That's it!

## Basic use

First, you need to load the library:

    library(secmarketstructure)

The basic command is `sec.get()`. Its first argument, `by.type`, takes a value
amongst `"security"`, `"exchange"`, `"decile"`, `"quartile"`, `"condfreq"`, `"hazard"` or `"survival"`. It defaults to `"security"`. Here is a simple example:

    dt <- sec.get()
    head(dt); cat("---\n"); tail(dt)

This returns:

      ticker     date security mcap.rank turn.rank volatility.rank price.rank
    1      A 20121001    Stock        10         9               5          9
    2     AA 20121001    Stock        10        10               5          4
    3   AACC 20121001    Stock         4         1               8          4
    4   AAME 20121001    Stock         2         1               1          2
    5    AAN 20121001    Stock         8         6               3          8
    6   AAON 20121001    Stock         6         3               6          7
      cancels trades lit.trades odd.lots hidden trades.for.hidden order.vol
    1  349597  24030      21643     5260   2387             20417  71979258
    2  495688  31763      29223     2938   2540             30267 301396722
    3   12195    117         99       79     18               117   1476755
    4      32      9          2        2      7                 9      9703
    5   71845   2857       2734      814    123              2129  12246413
    6   14406    333        283      189     50               333   1718838
      trade.vol  lit.vol odd.lot.vol hidden.vol trade.vol.for.hidden
    1   3040786  2698758      201108     342028              2266278
    2  11753368 11062439      138622     690929             10127996
    3      6361     5568        2061        793                 6361
    4      1000      300         100        700                 1000
    5    267562   255801       34248      11761               184213
    6     21639    18657        5794       2982                21639
    ---
           ticker     date security mcap.rank turn.rank volatility.rank price.rank
    867791   YMLI 20130628      ETF         2         3               1          1
    867792   YMLP 20130628      ETF         3         3               2          1
    867793    YXI 20130628      ETF         1         4               3          3
    867794    YYY 20130628      ETF         1         4               3          1
    867795   ZROZ 20130628      ETF         2         3               3          4
    867796    ZSL 20130628      ETF         2         4               4          4
           cancels trades lit.trades odd.lots hidden trades.for.hidden order.vol
    867791    2420     30         26        1      4                30   3038458
    867792   22201     78         66        5     12                78 172649613
    867793    9211     16         16       10      0                16   6625467
    867794    1074     17         17        1      0                16    833700
    867795   34485     77         63       23     14                77  29444316
    867796  426574   1620       1292      377    328              1472 174925407
           trade.vol lit.vol odd.lot.vol hidden.vol trade.vol.for.hidden
    867791     11488    9888          80       1600                11488
    867792    101939   96039         178       5900               101939
    867793      1027    1027         197          0                 1027
    867794      3294    3294           9          0                 3094
    867795     11378    8413         869       2965                11378
    867796    241594  203150       13360      38444               220088

When `by.type` is `"security"`, `"condfreq"`, `"hazard"`, `"survival"`, you can set the argument `year.quarter` to restrict the quarters that are loaded. All quarters (three as of October 15th, 2013) will be loaded otherwise. Acceptable values for the parameter are of the form `"2013.Q1"` or `c("2012.Q4", "2013.Q2")`, for instance:

    dt <- sec.get("condfreq", year.quarter = c("2013.Q1", "2013.Q2"))
    head(dt); cat("---\n"); tail(dt)

This returns: 

            cancel       trade cancel.sum trade.sum time     type year quarter
    1 0.3175481896 0.166385797  0.3175482 0.1663858    0 large_e1 2013      q1
    2 0.0001135286 0.003827689  0.3176617 0.1702135    1 large_e1 2013      q1
    3 0.0005227328 0.003511216  0.3181845 0.1737247    2 large_e1 2013      q1
    4 0.0017495279 0.003625801  0.3199340 0.1773505    3 large_e1 2013      q1
    5 0.0062576960 0.003947731  0.3261917 0.1812982    4 large_e1 2013      q1
    6 0.0074998062 0.003972285  0.3336915 0.1852705    5 large_e1 2013      q1
    ---
                cancel        trade cancel.sum trade.sum  time     type year
    298891 0.008409317 0.0000000000   99.94646  99.99906 23030 small_s9 2013
    298892 0.009642164 0.0000000000   99.95610  99.99906 23040 small_s9 2013
    298893 0.007955110 0.0000000000   99.96405  99.99906 23050 small_s9 2013
    298894 0.009421549 0.0009382271   99.97347 100.00000 23060 small_s9 2013
    298895 0.006644398 0.0000000000   99.98012 100.00000 23070 small_s9 2013
    298896 0.007500903 0.0000000000   99.98762 100.00000 23080 small_s9 2013
           quarter
    298891      q2
    298892      q2
    298893      q2
    298894      q2
    298895      q2
    298896      q2

### Security

The `"security"` options returns the metrics by individual security. This is the default for `sec.get()`.

    dt <- sec.get()
    head(dt); cat("---\n"); tail(dt)

For the results, see above.

### Exchange

The `"exchange"` options returns the metrics by exchange.

    dt <- sec.get("exchange")

This returns a list of 13 data.frames corresponding to the measures `"ETP_Cancel_to_Trade"`, `"ETP_Hidden_Rate"`, `"ETP_Hidden_Volume"`, `"ETP_Oddlot_Rate"`, `"ETP_Oddlot_Volume"`, `"ETP_Stock_Timeseries"`, `"ETP_Trade_Volume"`, `"Stock_Cancel_to_Trade"`, `"Stock_Hidden_Rate"`, `"Stock_Hidden_Volume"`, `"Stock_Oddlot_Rate"`, `"Stock_Oddlot_Volume"`, `"Stock_Trade_Volume"`.

### Decile

The `"decile"` option returns the stock market activity metrics by decile.

    dt <- sec.get("decile")
    head(dt, n=3); cat("---\n"); tail(dt, n=3)

This returns:

          date market.cap.decile1 market.cap.decile2 market.cap.decile3
    1 20121001           43.63022           21.86436           19.81577
    2 20121002           24.08093           29.85542           21.04473
    3 20121003           23.11467           20.63067           20.30188
      market.cap.decile4 market.cap.decile5 market.cap.decile6 market.cap.decile7
    1           21.42457           18.57635           20.76624           21.45042
    2           24.79160           23.10690           25.34812           24.83781
    3           21.06748           20.47450           20.43948           20.85782
      market.cap.decile8 market.cap.decile9 market.cap.decile10 price.decile1
    1           21.01014           20.51949            19.23601      10.91650
    2           25.39216           23.32315            21.81936      11.52307
    3           24.32544           21.90037            20.05301      11.95698
      price.decile2 price.decile3 price.decile4 price.decile5 price.decile6
    1      12.99371      12.82147      15.48712      15.77999      17.00550
    2      14.05253      15.51663      18.62393      18.55298      20.65653
    3      12.46198      13.58728      16.57791      16.69854      17.13018
      price.decile7 price.decile8 price.decile9 price.decile10 turnover.decile1
    1      18.33693      19.79525      21.88015       26.93025         124.3218
    2      20.45950      23.25604      25.34556       30.12258         188.8048
    3      20.01615      20.27971      23.34418       29.19066         153.3914
      turnover.decile2 turnover.decile3 turnover.decile4 turnover.decile5
    1         82.85601         35.39384         27.10750         25.32405
    2         89.01944         49.49007         36.32343         34.03184
    3         65.16057         52.88848         34.64390         27.57522
      turnover.decile6 turnover.decile7 turnover.decile8 turnover.decile9
    1         22.95303         22.60908         20.58547         18.86139
    2         27.36349         26.71643         24.60849         22.13054
    3         27.80185         25.04866         24.49010         20.04456
      turnover.decile10 volatility.decile1 volatility.decile2 volatility.decile3
    1          15.10640           20.75338           20.29986           20.80909
    2          15.77787           26.31808           25.61471           25.04289
    3          14.13167           23.90641           24.83132           23.47622
      volatility.decile4 volatility.decile5 volatility.decile6 volatility.decile7
    1           21.78730           21.19499           19.96307           19.29848
    2           24.41227           22.69582           22.15454           22.88099
    3           22.29211           19.62361           20.87520           21.81087
      volatility.decile8 volatility.decile9 volatility.decile10
    1           16.49905           17.34077            12.05308
    2           20.62878           17.75779            10.49486
    3           17.28010           13.86830            10.08756
                              type
    1 Decile_Cancel_to_Trade_Stock
    2 Decile_Cancel_to_Trade_Stock
    3 Decile_Cancel_to_Trade_Stock
    ---
             date market.cap.decile1 market.cap.decile2 market.cap.decile3
    1114 20130626           8.493686           6.698045           5.649647
    1115 20130627           5.664361           6.806482           5.534389
    1116 20130628           5.103297           4.841017           5.965322
         market.cap.decile4 market.cap.decile5 market.cap.decile6
    1114           4.477081           3.941719           3.411711
    1115           5.294283           3.875502           3.577837
    1116           5.146514           4.212699           3.845129
         market.cap.decile7 market.cap.decile8 market.cap.decile9
    1114           3.051215           3.120888           2.530176
    1115           3.285525           2.926735           2.723005
    1116           3.567325           2.847791           2.599569
         market.cap.decile10 price.decile1 price.decile2 price.decile3
    1114            3.129355      6.056330      5.326767      5.145815
    1115            3.243904      6.745275      5.111943      4.684839
    1116            3.135467      6.467111      5.068785      4.991146
         price.decile4 price.decile5 price.decile6 price.decile7 price.decile8
    1114      4.026795      4.080810      3.224597      3.545967      2.707312
    1115      4.119582      4.269778      3.711907      3.915644      2.770188
    1116      4.142036      3.791359      3.373367      3.857866      2.757875
         price.decile9 price.decile10 turnover.decile1 turnover.decile2
    1114      2.366170       1.991935        0.3989605         1.523860
    1115      2.390516       2.007332        0.6753882         1.499085
    1116      2.391419       2.015577        0.3360736         2.355814
         turnover.decile3 turnover.decile4 turnover.decile5 turnover.decile6
    1114         2.021097         2.299718         2.340916         2.494526
    1115         1.845370         2.649350         2.272686         2.494483
    1116         2.339826         2.511259         2.866010         2.571826
         turnover.decile7 turnover.decile8 turnover.decile9 turnover.decile10
    1114         2.555433         2.969357         3.480296          4.201612
    1115         2.599348         3.320731         3.390814          4.616222
    1116         2.971767         3.607445         3.941593          5.174364
         volatility.decile1 volatility.decile2 volatility.decile3
    1114           2.729897           2.566546           2.844122
    1115           2.732253           2.687277           3.076177
    1116           2.776373           2.828893           2.520710
         volatility.decile4 volatility.decile5 volatility.decile6
    1114           2.937502           3.164703           3.117679
    1115           2.799248           3.389358           3.338600
    1116           3.174840           2.966378           3.335558
         volatility.decile7 volatility.decile8 volatility.decile9
    1114           3.383663           3.933291           5.015487
    1115           3.730323           3.730321           4.641018
    1116           3.443827           4.157449           4.754544
         volatility.decile10                      type
    1114            6.446297 Decile_Trade_Volume_Stock
    1115            6.797712 Decile_Trade_Volume_Stock
    1116            6.006835 Decile_Trade_Volume_Stock

### Quartile

The `"quartile"` option returns the ETP market activity metrics by quartile.

    dt <- sec.get("quartile")
    head(dt, n=3); cat("---\n"); tail(dt, n=3)

This returns:

          date market.cap.quartile1 market.cap.quartile2 market.cap.quartile3
    1 20121001            1480.0270             826.9706             283.2449
    2 20121002            1898.5021             877.0172             306.2567
    3 20121003             927.9713             772.3199             238.7192
      market.cap.quartile4 price.quartile1 price.quartile2 price.quartile3
    1             64.71120       101.88280        145.3225        87.94697
    2             80.40060       118.24553        146.7887       108.82332
    3             71.19429        86.45947        129.2504        96.04267
      price.quartile4 turnover.quartile1 turnover.quartile2 turnover.quartile3
    1        82.67684           1488.827           427.9933           126.2386
    2       101.64901           2259.203           530.9803           163.9071
    3        90.87780           2625.672           470.0155           152.6164
      turnover.quartile4 volatility.quartile1 volatility.quartile2
    1           76.60054             54.70915             61.56911
    2           90.06234             66.99389             70.12861
    3           77.65417             76.61781             74.86795
      volatility.quartile3 volatility.quartile4                         type
    1             73.79360             144.1286 Quartile_Cancel_to_Trade_ETP
    2            104.00320             147.3963 Quartile_Cancel_to_Trade_ETP
    3             79.53663             135.2842 Quartile_Cancel_to_Trade_ETP
    ---
             date market.cap.quartile1 market.cap.quartile2 market.cap.quartile3
    1114 20130626           0.03282002           0.02879581            0.1224610
    1115 20130627           0.03758774           0.03024957            0.1108266
    1116 20130628           0.02820979           0.03128036            0.1358462
         market.cap.quartile4 price.quartile1 price.quartile2 price.quartile3
    1114            0.3496215       0.3320652       0.1299123       0.2920013
    1115            0.3363824       0.2433544       0.1606037       0.2829858
    1116            0.3225184       0.2525735       0.1666033       0.2389902
         price.quartile4 turnover.quartile1 turnover.quartile2 turnover.quartile3
    1114       0.3890146        0.010052146         0.04749936         0.06728148
    1115       0.4033349        0.010933678         0.04105564         0.05946769
    1116       0.4118028        0.004001159         0.05509796         0.05412292
         turnover.quartile4 volatility.quartile1 volatility.quartile2
    1114          0.5347178           0.06168494            0.2593793
    1115          0.5827774           0.08325276            0.2762830
    1116          0.4866619           0.07840489            0.2399944
         volatility.quartile3 volatility.quartile4                      type
    1114            0.2937021            0.6383177 Quartile_Trade_Volume_ETP
    1115            0.1896724            0.6680029 Quartile_Trade_Volume_ETP
    1116            0.2025420            0.7103712 Quartile_Trade_Volume_ETP

### Condfreq

The `"condfreq"` option returns the conditional cancel and trade duration distributions for nine fixed time scales.

    dt <- sec.get("condfreq")
    head(dt); cat("---\n"); tail(dt)

This returns:

           cancel       trade cancel.sum trade.sum time     type year quarter
    1 0.340570849 0.173315082  0.3405708 0.1733151    0 large_e1 2012      q4
    2 0.001021596 0.003339928  0.3415924 0.1766550    1 large_e1 2012      q4
    3 0.011059315 0.004773556  0.3526518 0.1814286    2 large_e1 2012      q4
    4 0.016097504 0.006164821  0.3687493 0.1875934    3 large_e1 2012      q4
    5 0.012416354 0.006586214  0.3811656 0.1941796    4 large_e1 2012      q4
    6 0.010761291 0.006860454  0.3919269 0.2010401    5 large_e1 2012      q4
    ---
                cancel        trade cancel.sum trade.sum  time     type year
    448339 0.008409317 0.0000000000   99.94646  99.99906 23030 small_s9 2013
    448340 0.009642164 0.0000000000   99.95610  99.99906 23040 small_s9 2013
    448341 0.007955110 0.0000000000   99.96405  99.99906 23050 small_s9 2013
    448342 0.009421549 0.0009382271   99.97347 100.00000 23060 small_s9 2013
    448343 0.006644398 0.0000000000   99.98012 100.00000 23070 small_s9 2013
    448344 0.007500903 0.0000000000   99.98762 100.00000 23080 small_s9 2013
           quarter
    448339      q2
    448340      q2
    448341      q2
    448342      q2
    448343      q2
    448344      q2

### Hazard

The `"hazard"` option returns the hazard function for the conditional cancel and trade distribution.

    dt <- sec.get("hazard")
    head(dt); cat("---\n"); tail(dt)

This returns:

      time_ms    hazard               type year quarter
    1       1  10.36347 large_e_cancelhaz1 2012      q4
    2       2 112.10309 large_e_cancelhaz1 2012      q4
    3       3 162.35345 large_e_cancelhaz1 2012      q4
    4       4 125.30840 large_e_cancelhaz1 2012      q4
    5       5 108.88927 large_e_cancelhaz1 2012      q4
    6       6  94.05550 large_e_cancelhaz1 2012      q4
    ---
           time_ms     hazard              type year quarter
    197949    9988 0.07480789 small_s_tradehaz2 2013      q2
    197950    9990 0.07480823 small_s_tradehaz2 2013      q2
    197951    9992 0.00000000 small_s_tradehaz2 2013      q2
    197952    9994 0.07480893 small_s_tradehaz2 2013      q2
    197953    9996 0.00000000 small_s_tradehaz2 2013      q2
    197954    9998 0.00000000 small_s_tradehaz2 2013      q2

### Survival

The `"survival"` option returns the survival and cumulative distribution functions for the conditional cancel and trade distribution.

    dt <- sec.get("survival")
    head(dt); cat("---\n"); tail(dt)

This returns:

      bin  survivor          cdf        xaxis               type year quarter
    1   1        NA           NA 1.666667e-08 large_e_cancelsurv 2012      q4
    2   2 0.9998775 0.0001224591 3.333333e-08 large_e_cancelsurv 2012      q4
    3   3 0.9997152 0.0002847795 5.000000e-08 large_e_cancelsurv 2012      q4
    4   4 0.9995900 0.0004100443 6.666667e-08 large_e_cancelsurv 2012      q4
    5   5 0.9994811 0.0005188830 8.333333e-08 large_e_cancelsurv 2012      q4
    6   6 0.9993871 0.0006128853 1.000000e-07 large_e_cancelsurv 2012      q4
    ---
                  bin  survivor        cdf    xaxis              type year quarter
    791985 1750000000 0.9558198 0.04418020 29.16667 small_s_tradesurv 2013      q2
    791986 1760000000 0.9557547 0.04424532 29.33333 small_s_tradesurv 2013      q2
    791987 1770000000 0.9556887 0.04431130 29.50000 small_s_tradesurv 2013      q2
    791988 1780000000 0.9556292 0.04437077 29.66667 small_s_tradesurv 2013      q2
    791989 1790000000 0.9555696 0.04443036 29.83333 small_s_tradesurv 2013      q2
    791990 1800000000 0.9555234 0.04447665 30.00000 small_s_tradesurv 2013      q2

## License

This library is distributed along the terms of the MIT license.


