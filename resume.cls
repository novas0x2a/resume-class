\NeedsTeXFormat{LaTeX2e}[1995/12/01]

\ProvidesClass{resume}
              [2007/02/18 v1.2
               (My Resume Class)]

\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{article}%
    \PassOptionsToClass{\CurrentOption}{geometry}%
}
\ProcessOptions

\LoadClass{article}
\RequirePackage[margin=0.5in]{geometry}
\RequirePackage{calc}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{eso-pic}

\setitemize[1]{nolistsep}
\setitemize[2]{nolistsep}

\pagestyle{fancy}

\let\@oddhead\@empty
\let\@evenhead\@empty
\cfoot{\thepage\ of \pageref{@End}}

\newlength{\@myskip}
\setlength{\@myskip}{5pt}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\tabskip}{0pt}

\def\baselinestretch{0.9}
\def\arraystretch{0.3}

\newlength{\@lwidth}
\newlength{\@mwidth}

\setlength{\@lwidth}{0.65in}
\setlength{\@mwidth}{.75cm}

\newdimen\@topfirst
\def\@uglyhack{10pt}

\AddToShipoutPicture{%
  \begingroup
  \setlength{\@tempdima}{\@lwidth + 0.5in + \@mwidth}%
  \setlength{\@tempdimb}{\paperheight-\@topfirst-0.5in}%
  \linethickness{\LenToUnit{0.4pt}}%
  \put(\LenToUnit{\@tempdima},\LenToUnit{0pt}){%
    \framebox(0,\LenToUnit{\@tempdimb}){}}%
  \endgroup
  \global\@topfirst=\@uglyhack
}

%\AddToShipoutPicture{%
%  \ifdim\pagetotal>\pagegoal
%    \let\tmp\pagegoal
%  \else
%    \let\tmp\pagetotal
%  \fi
%  \begingroup
%  \setlength{\@tempdima}{\@lwidth + 0.5in + \@mwidth}%
%  \setlength{\@tempdimb}{\paperheight-\@topfirst-0.5in}%
%  \setlength{\@tempdimc}{\paperheight-\tmp-0.5in}%
%  \setlength{\@tempdimb}{\@tempdimb-\@tempdimc}
%  \linethickness{\LenToUnit{0.4pt}}%
%  \put(\LenToUnit{\@tempdima},\LenToUnit{\@tempdimc}){%
%    \framebox(0,\LenToUnit{\@tempdimb}){}%
%    %\line(1,0){\@tempdimb}%
%  }%
%  %\setlength{\@tempdima}{\@tempdima+1in}
%  %\put(\LenToUnit{\@tempdima},\LenToUnit{\@tempdimc}){%
%  %  \framebox(\LenToUnit{\paperwidth},0){}%
%  %}%
%  \endgroup
%  \global\@topfirst=\@uglyhack
%}



%\AddToShipoutPicture{%
%  \begingroup
%  \def\@off{\footskip}
%  \setlength{\@tempdimb}{\paperwidth-\@off-\@off}%
%  \setlength{\@tempdimc}{\paperheight-\@off-\@off}%
%  \linethickness{\LenToUnit{0.4pt}}%
%  \put(\LenToUnit{\@off},\LenToUnit{\@off}){%
%    \framebox(\LenToUnit{\@tempdimb},\LenToUnit{\@tempdimc}){}}%
%  \endgroup  
%}

\newlength{\tmp@rule}
\def\shiftrule#1{%
    \vbox to #1{
        \vss
        \hrule width \linewidth height 0.4pt depth 0pt
        \vss
    }
}

\newcommand{\myline}[1][0.5\@myskip]{\shiftrule{#1}}

\newlength{\tmp@block}
\newenvironment{block}[1][]{%
    \def\@arg{#1}%
    \setlength{\tmp@block}{\linewidth - \@lwidth - \@mwidth - 3.65pt}%
    \ifx\@arg\empty\else\myline\nobreak\fi
    \halign to \linewidth\bgroup
            \vtop{\hsize=\@lwidth   \tabskip=\@mwidth   ##\hfill} &
            \vtop{\hsize=\tmp@block \tabskip=0pt        ##\hfill}\cr

            \vtop{\raggedright\catform{#1}} &
            \vtop\bgroup\setlength{\linewidth}{\tmp@block}%
}{%
    \egroup \cr \egroup
}

\def\catform#1{\textsc{#1}}
\def\locform#1{\textbf{#1}}
\def\dateform#1{{\small\textsl{#1}}}
\def\jobform#1{{\small#1}}

\def\job#1#2#3{\jobform{#1}\leaders\hbox to 0.75em{\hss.\hss}\hfill\dateform{#2 -- #3}\par}

\newcounter{sec}
\newcounter{place}[sec]

\def\thesec{Section: \arabic{sec}}
\def\theplace{Place: \arabic{place}}

\def\interplace{\myline[\@myskip]}

\newif\ifshowrefs
\newif\ifclosed

\renewenvironment{section}[1]{%
    \stepcounter{sec}%
    \gdef\secname{#1}%
    \begin{block}[\secname]%
    \closedfalse
}{%
    \ifclosed\else\end{block}\fi
}

\newif\if@newpg\@newpgfalse
\newif\if@lastodd\@lastoddtrue

\def\getpagenum#1{%
    \edef\@tempa{\@nameuse{r@#1}}
    \edef\thispage{\expandafter\@cdr\@tempa\@nil\space}%
    \ifx\thispage\space\def\thispage{0}\fi%
}

\def\setnew#1{%
    \getpagenum{end-#1}
    \ifodd\thispage
        \if@lastodd
            \global\@newpgfalse
        \else
            \global\@newpgtrue
        \fi
        \global\@lastoddtrue
    \else
        \if@lastodd
            \global\@newpgtrue
        \else
            \global\@newpgfalse
        \fi
        \global\@lastoddfalse
    \fi
}

\newlength{\@pagetotal}

\newenvironment{place}[2][]{%
    \setnew{#2}%
    \stepcounter{place}%
    \ifdim\@topfirst=\@uglyhack\else
        \ifdim\@topfirst=0pt
            \setlength\@pagetotal{\pagetotal-0.4pt}
            \global\@topfirst=\@pagetotal
        \fi
    \fi
    \ifnum\value{place}=\@ne
    \else
        \if@newpg
            \begin{block}[\secname\space (cont.)]%
            \global\@newpgfalse
        \else
            \begin{block}%
            \interplace
        \fi
    \fi
    \gdef\placename{#2}%
    #1 \locform{\placename}\par
}{%
    \end{block}\label{end-\placename}\closedtrue
}

\def\items{\begin{itemize}}
\def\enditems{\end{itemize}}

% This creates a list type.
%   #1: name
%   #2: what \and expands to
%   #3: prefix
\long\def\listtype#1#2#3{
    \expandafter\gdef\csname#1\endcsname##1{{%
        \expandafter\gdef\csname @#1\endcsname{{%
            \def\and{#2}
            #3##1%
        }}%
        \def\and{and }
        \expandafter\xdef\csname my#1\endcsname{{##1}}
    }}
}

\def\next{\par}%

\listtype{address}{%
    \egroup\hss\vtop\bgroup\hsize=0.5\linewidth %
}{%
    \vtop\bgroup\hsize=0.5\linewidth %
}

\def\email#1{\def\@email{#1}\def\myemail{#1}}
\def\name#1{\def\@name{#1}\def\myname{#1}}

\newlength{\@tmp@skill}
\newenvironment{skilltable}[1]{%
    \place[\centering]{#1}
    \setlength{\@tmp@skill}{0.5\linewidth - .2cm - 0.09pt}
    \begin{tabular*}{\linewidth}[t]{
                                    @{\hfil}
                                    p{\@tmp@skill}
                                    @{\hspace{.2cm}}
                                    |
                                    @{\hspace{.2cm}}
                                    p{\@tmp@skill}
                                    @{\hfil}
                                    }
}{%
    \end{tabular*}
    \endplace
}

\def\skill#1#2{%
    \raggedleft #1 & #2 \\[3pt]
}

\def\reference#1{%
    \textbf{#1}
    \setitemize[1]{topsep=5pt, itemsep=0pt}
    \items
}
\def\endreference{%
    \enditems
    \setitemize[1]{nolistsep}
}

\def\exprt#1{\skill{#1}{Expert}}
\def\inter#1{\skill{#1}{Intermediate}}
\def\basic#1{\skill{#1}{Basic}}

%\let\OldItem\item
%\renewcommand{\item}[2][---]{\OldItem[#1] #2}

\AtBeginDocument{%
    \vtop{%
        \centering
        {\Large{\@name}}\par
        \hbox to \hsize{%
            \hfil
            \@address \egroup
            \hfil
        }\par
        \@email\par
        \vskip 5pt
    }%
}%

\AtEndDocument{%
    \label{@End}
    \getpagenum{@End}
    \ifnum\thispage=\@ne
        \pagestyle{empty}
    \fi
}

\raggedbottom
\endinput
% vim: set ft=tex nospell :
