#Logistic Regression
## File Set-Up
We only care about the sites that are polymorphic across the lineages. Using shell commands to speed the process up, we want to keep only positions that have at least 2 alleles represeted among the lineages. If the allele is consistent among all lineages, there is no reason to consider it. 

Sync files come in the format below. This is one line of data from the sync file (generated from the mpileup using Popoolation)
```
2R	2092604	A	246:0:0:0:0:0	173:0:0:0:0:0	186:0:0:0:0:0	174:0:0:0:0:0	188:0:0:0:0:0	179:0:0:0:0:0	209:0:0:0:0:0	175:0:0:0:0:0	154:0:0:0:0:0	159:0:0:0:0:0	163:0:0:0:0:0	195:0:0:0:0:0	159:0:0:0:0:0	178:0:0:0:0:0	187:0:0:0:0:0	170:0:0:0:0:0	112:0:0:0:0:0	167:0:0:0:0:0	159:0:0:0:0:0	215:0:0:0:0:0	181:0:0:0:0:0	220:0:0:0:0:0	215:0:0:0:0:0	205:0:0:0:0:0	109:0:0:0:0:0	168:0:0:0:0:0	194:0:0:0:0:0	198:0:0:0:0:0	168:0:0:0:0:0	162:0:0:0:0:0	206:0:0:1:0:0
```
The first three columns are chromosome, postion, and reference allele. After that, each column represents the allele counts for a lineage in this pattern A:T:C:G:N:Del where A,T,C,G are bases, N is missing data, and Del is a deletion at the site. 

We really want to sum up all the values in each category for a row to find out if several bases are present for each position

First, we split the coulmns based on the colon
```
awk 'gsub(/:/,"\t")' practice2.sync > practice2_manycols.sync
```
We now have so many columns (189!). We then want to add all the columns corresponding to certain categories and add this to the end of each line. I ended up generating 6 new columns. To get all the column values I needed for a category, I put all the columns into excel and sorted so I had a list of columns associated with each base. Adding plus signs was annoying though.
```
awk 'BEGIN{OFS="\t"} {$190 = $4+$10+$16+$22+$28+$34+$40+$46+$52+$58+$64+$70+$76+$82+$88+$94+$100+$106+$112+$118+$124+$130+$136+$142+$148+$154+$160+$166+$172+$178+$184;} {$191 = $5+$11+$17+$23+$29+$35+$41+$47+$53+$59+$65+$71+$77+$83+$89+$95+$101+$107+$113+$119+$125+$131+$137+$143+$149+$155+$161+$167+$173+$179+$185;} {$192 = $6+$12+$18+$24+$30+$36+$42+$48+$54+$60+$66+$72+$78+$84+$90+$96+$102+$108+$114+$120+$126+$132+$138+$144+$150+$156+$162+$168+$174+$180+$186;} {$193 = $7+$13+$19+$25+$31+$37+$43+$49+$55+$61+$67+$73+$79+$85+$91+$97+$103+$109+$115+$121+$127+$133+$139+$145+$151+$157+$163+$169+$175+$181+$187;} {$194 = $8+$14+$20+$26+$32+$38+$44+$50+$56+$62+$68+$74+$80+$86+$92+$98+$104+$110+$116+$122+$128+$134+$140+$146+$152+$158+$164+$170+$176+$182+$188;} {$195 = $9+$15+$21+$27+$33+$39+$45+$51+$57+$63+$69+$75+$81+$87+$93+$99+$105+$111+$117+$123+$129+$135+$141+$147+$153+$159+$165+$171+$177+$183+$189;}{print $0}' practice2_manycols.sync > practice2_manycols_sums.sync
```

We then want to see which rows have more then one allele represented among the populations. Ian and I decided that the cut off should be a count of 10 for across the population to be included. We will only be looking at the last 6 columns since those have our sums. 


