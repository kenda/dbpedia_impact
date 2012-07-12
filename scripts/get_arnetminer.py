import urllib2
import json

# fetch bib data via rest interface
# u=oyster is a demo user from their tutorial pages
url = "http://arnetminer.org/services/search-publication?q=dbpedia&u=oyster&num=100"
data = urllib2.urlopen(url).read()
data = json.loads(data)["Results"]

data2 = []
# iterate over result entries
for item in data:
    # iterate only over relevant fields
    a = {}
    for field in ["Title", "Authors", "Pubyear", "Jconfname", "Pubkey"]:
        if item[field]:
            a[field] = item[field]
    data2.append(a)

bibstr = ""
for item in data2:
    if item["Pubkey"].startswith("conf"):
        bibstr += "@inproceedings{\n"
        if item["Jconfname"]:
            bibstr += "Booktitle = {%s},\n" % item["Jconfname"]
    elif item["Pubkey"].startswith("journals"):
        bibstr += "@article{\n"
        if item["Jconfname"]:
            bibstr += "Journal = {%s},\n" % item["Jconfname"]
    else:
        bibstr += "@misc{"

    if item["Title"]:
        bibstr += "Title = {%s},\n" % item["Title"]
    if item["Pubyear"]:
        bibstr += "Year = {%s},\n" % item["Pubyear"]
    if item["Authors"]:
        bibstr += "Author = {%s}\n" % item["Authors"].replace(",", " and ")

    bibstr += "}\n"

with open("arnetminer.bib", "w") as f:
    f.write(bibstr.encode('utf-8'))

print "wrote %s entries" % len(data2)
