### Sets
$A\subseteq B \iff\forall x\in A,x\in B$
$A\subset B \iff\forall x\in A,x\in B\;\land\;\exists y\in B,y\notin A$
$A=B\iff A\subseteq B\;\land\;B\subseteq A$
$\mathbb{P}(A)$ is the set of all subsets of $A$. $|\mathbb{P}(A)|=2^{|A|}$
### Induction
Basis: show equation holds for smallest $n$
Inductive Step: Assume equation holds \[Show equation holds for $n+1$]
### Number Theory
$gcd(a,b)*lcm(a,b)=|a*b|$
### Cardinality and Counting
\# of integers $\leq k$ divisible by $a=\lfloor k/a\rfloor$
\# of integers $\leq k$ divisible by $a$ or $b=\lfloor k/a\rfloor +\lfloor k/b\rfloor -\lfloor k/a*b\rfloor$ (PIE)

\# of relations $:S\rightarrow T=2^{|S|*|T|}$
\# of functions $:S\rightarrow T=|T|^{|S|}$
\# of one-to-one functions $:S\rightarrow T=(|S|\leq|T|)\;?\;|T|!/(|T|-|S|)!\;:\;0$
\# of non-onto functions $:S\rightarrow T=\sum_{i=1}^{|T|} (-1)^{i-1} \binom{|T|}{i} (|T| - i)^{|S|}$

Countable Sets:
- List all elements
- Find formula for $n$th element
- Find an injection $:S\rightarrow \mathbb{N}$
- Union of countable sets
- Cartisian product of countable sets

Uncountable Sets:
- Find a bijection $: S \rightarrow$ uncountable set
- There is no onto function $:S\rightarrow\mathbb{P}(S)$

CSB
- Find injections $:S\rightarrow T,\;T\rightarrow S$
	- This means $\exists bijection:S\rightarrow T,\;\therefore |S|=|T|$: