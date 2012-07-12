#! /bin/sh

# uris per sparql holen
# query:
# SELECT DISTINCT ?s
# WHERE {
#   { ?s dc:subject ?subject.
#     FILTER regex(?subject, "dbpedia", "i")
#   }
#   UNION 
#   { ?s swrc:abstract ?abstract.
#     FILTER regex(?abstract, "dbpedia", "i")
#   }
# }
URIS=$(curl -s -H "Accept: application/sparql-results+xml" "http://data.semanticweb.org/sparql?query=PREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX+swrc%3A+%3Chttp%3A%2F%2Fswrc.ontoware.org%2Fontology%23%3E%0D%0ASELECT+DISTINCT+%3Fs%0D%0AWHERE+%7B%0D%0A++%7B+%3Fs+dc%3Asubject+%3Fsubject.%0D%0A++++FILTER+regex%28%3Fsubject%2C+%22dbpedia%22%2C+%22i%22%29%7D%0D%0A++UNION+%0D%0A++%7B+%3Fs+swrc%3Aabstract+%3Fabstract.%0D%0A++++FILTER+regex%28%3Fabstract%2C+%22dbpedia%22%2C+%22i%22%29%0D%0A++%7D%0D%0A%7D" | sed -n 's/.*uri>\(.*\)<\/uri>.*/\1/p')

# über empfangene URIs iterieren
for URI in $URIS; do
    # bibtex link aus html ansicht der uris holen
    BIBURI=$(curl -s $URI | grep bibtex | sed -n 's/.*href="\(.*\)">.*/\1/p')
    BIBURI="http://data.semanticweb.org$BIBURI"

    # testen ob bibtex link vorhanden war
    if [ $BIBURI != "http://data.semanticweb.org" ]; then
        # bibtex abrufen und nach STDIN schreiben
        curl -s $BIBURI
        echo ""
    fi
done

exit 0
