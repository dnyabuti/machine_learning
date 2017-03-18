((*- extends 'article.tplx' -*))
% Author and Title from metadata
((* block maketitle *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["author"]: -*))
    \author{((( nb.metadata["latex_metadata"]["author"] )))}
((*- endif *))
((*- else -*))
    \author{Jikai Tang, Josh Janzen, Davis Nyabuti, Chenchao Lu, Tong Wu, Usman Waheed}
((*- endif *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["affiliation"]: -*))
    \affiliation{((( nb.metadata["latex_metadata"]["affiliation"] )))}
((*- endif *))
((*- endif *))

((*- if nb.metadata["latex_metadata"]: -*))
((*- if nb.metadata["latex_metadata"]["title"]: -*))
    \title{SEIS 763 - Machine Learning - Project Plan}
((*- endif *))
((*- else -*))
    \title{SEIS 763 - Machine Learning - Project Plan }
((*- endif *))

\date{\today}
\maketitle
((* endblock maketitle *))
