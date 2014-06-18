$('table tr td:first-child').filter(function() {
    return $(this).text() == "#{@word.id}"
}).parent().children().eq(2).html("<%= j render(partial: 'words/word_flags_span', locals: { word: @word }) %>")

