((*- extends 'article.tplx' -*))
% Author and Title from metadata
((* block maketitle *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["author"]: -*))
    \author{((( nb.metadata["latex_metadata"]["author"] )))}
((*- endif *))
((*- else -*))
    \author{Davis Nyabuti}
((*- endif *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["affiliation"]: -*))
    \affiliation{((( nb.metadata["latex_metadata"]["affiliation"] )))}
((*- endif *))
((*- endif *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["title"]: -*))
    \title{((( nb.metadata["latex_metadata"]["title"] )))}
((*- endif *))
((*- else -*))
    \title{((( resources.metadata.name )))}
((*- endif *))

\date{\today}
\maketitle
((* endblock maketitle *))
