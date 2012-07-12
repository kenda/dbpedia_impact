#! /bin/sh

# get uris via sparql
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

for URI in $URIS; do
    # extract bibtex link out of the html page
    BIBURI=$(curl -s $URI | grep bibtex | sed -n 's/.*href="\(.*\)">.*/\1/p')
    BIBURI="http://data.semanticweb.org$BIBURI"

    # test if bibtex link was available
    if [ $BIBURI != "http://data.semanticweb.org" ]; then
        # get bibtex and write to STDOUT
        curl -s $BIBURI
        echo ""
    fi
done

exit 0
