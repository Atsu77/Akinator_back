class ExtractionAlgorithm
  attr_reader :game, :query

  def initialize(game)
    Rails.logger.debug('ExtractionAlgorithm initialized.')
    @game = game
    @query = Comic.all
  end

  def compute
    progresses = @game.progresses
    progresses.each do |progress|
      question = progress.question

      case question.algorithm
      when 'genre_match'
        genre_match(progress)
      when 'serialization_end'
        serialization_end?(progress)
      when 'publisher_match'
        publisher_match(progress)
      else
        raise Exception('Invalid algorithm. --> ' + question.algorithm.to_s)
      end

      Rails.logger.debug('On the way query id' + @query.to_sql.to_s)
      Rails.logger.debug('On the way query id' + @query.pluck(:title).to_a.to_s)
    end
    @query
  end

  private

  def genre_match(progress)
    @query = @query.where('comics.genre like ?', "%#{progress.question.eval_value}%") if progress.yes_answer?

    @query = @query.where.not('comics.genre like ?', "%#{progress.question.eval_value}%") if progress.no_answer?
  end

  def serialization_end?(progress)
    @query = @query.where.not('comics.serialization_end_year is null') if progress.yes_answer?

    @query = @query.where('comics.serialization_end_year is null') if progress.no_answer?
  end

  def publisher_match(progress)
    @query = @query.where('comics.publisher like ?', "%#{progress.question.eval_value}%") if progress.yes_answer?

    @query = @query.where.not('comics.publisher like ?', "%#{progress.question.eval_value}%") if progress.no_answer?
  end
end
