function [n,xout]=spendHistogram(data,spendEntryIndex,numberOfBins)

%Args, in:
%data - men's, women's or noEmail-data
%spendEntryIndex - The column index of the spend amount in usd
%numberOfBins - number of bins in the histogram
%out:
%n - number of bins
%xout - 

[n,xout]=hist(data(:,spendEntryIndex),numberOfBins);
hist(xout,n)
end