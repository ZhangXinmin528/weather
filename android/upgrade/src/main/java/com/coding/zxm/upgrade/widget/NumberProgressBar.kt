package com.coding.zxm.upgrade.widget

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.os.Bundle
import android.os.Parcelable
import android.util.AttributeSet
import android.view.View
import com.coding.zxm.upgrade.R

/**
 * Created by daimajia on 14-4-30.
 */
class NumberProgressBar @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {
    private val default_text_color = Color.rgb(66, 145, 241)
    private val default_reached_color = Color.rgb(66, 145, 241)
    private val default_unreached_color = Color.rgb(204, 204, 204)
    private val default_progress_text_offset: Float
    private val default_text_size: Float
    private val default_reached_bar_height: Float
    private val default_unreached_bar_height: Float
    private var mMaxProgress = 100

    /**
     * Current progress, can not exceed the max progress.
     */
    private var mCurrentProgress = 0

    /**
     * The progress area bar color.
     */
    private var mReachedBarColor: Int

    /**
     * The bar unreached area color.
     */
    private var mUnreachedBarColor: Int
    /**
     * Get progress text color.
     *
     * @return progress text color.
     */
    /**
     * The progress text color.
     */
    var textColor: Int
        private set

    /**
     * The progress text size.
     */
    private var mTextSize: Float

    /**
     * The height of the reached area.
     */
    var reachedBarHeight: Float

    /**
     * The height of the unreached area.
     */
    var unreachedBarHeight: Float

    /**
     * The suffix of the number.
     */
    private var mSuffix = "%"

    /**
     * The prefix.
     */
    private var mPrefix = ""

    /**
     * The width of the text that to be drawn.
     */
    private var mDrawTextWidth = 0f

    /**
     * The drawn text start.
     */
    private var mDrawTextStart = 0f

    /**
     * The drawn text end.
     */
    private var mDrawTextEnd = 0f

    /**
     * The text that to be drawn in onDraw().
     */
    private var mCurrentDrawText: String? = null

    /**
     * The Paint of the reached area.
     */
    private var mReachedBarPaint: Paint? = null

    /**
     * The Paint of the unreached area.
     */
    private var mUnreachedBarPaint: Paint? = null

    /**
     * The Paint of the progress text.
     */
    private var mTextPaint: Paint? = null

    /**
     * Unreached bar area to draw rect.
     */
    private val mUnreachedRectF = RectF(0f, 0f, 0f, 0f)

    /**
     * Reached bar area rect.
     */
    private val mReachedRectF = RectF(0f, 0f, 0f, 0f)

    /**
     * The progress text offset.
     */
    private val mOffset: Float

    /**
     * Determine if need to draw unreached area.
     */
    private var mDrawUnreachedBar = true
    private var mDrawReachedBar = true
    var progressTextVisibility = true
        private set

    /**
     * Listener
     */
    private var mListener: OnProgressBarListener? = null
    private val mCicrlePaint: Paint? = null
    override fun getSuggestedMinimumWidth(): Int {
        return mTextSize.toInt()
    }

    override fun getSuggestedMinimumHeight(): Int {
        return Math.max(
            mTextSize.toInt(),
            Math.max(reachedBarHeight.toInt(), unreachedBarHeight.toInt())
        )
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        setMeasuredDimension(measure(widthMeasureSpec, true), measure(heightMeasureSpec, false))
    }

    private fun measure(measureSpec: Int, isWidth: Boolean): Int {
        var result: Int
        val mode = MeasureSpec.getMode(measureSpec)
        val size = MeasureSpec.getSize(measureSpec)
        val padding = if (isWidth) paddingLeft + paddingRight else paddingTop + paddingBottom
        if (mode == MeasureSpec.EXACTLY) {
            result = size
        } else {
            result = if (isWidth) suggestedMinimumWidth else suggestedMinimumHeight
            result += padding
            if (mode == MeasureSpec.AT_MOST) {
                result = if (isWidth) {
                    Math.max(result, size)
                } else {
                    Math.min(result, size)
                }
            }
        }
        return result
    }

    override fun onDraw(canvas: Canvas) {
        if (progressTextVisibility) {
            calculateDrawRectF()
        } else {
            calculateDrawRectFWithoutProgressText()
        }
        if (mDrawReachedBar) {
            canvas.drawRect(mReachedRectF, mReachedBarPaint!!)
        }
        if (mDrawUnreachedBar) {
            canvas.drawRect(mUnreachedRectF, mUnreachedBarPaint!!)
        }
        if (progressTextVisibility) {
//            float start = (mUnreachedRectF.left + mReachedRectF.right) / 2.0f;
//            float radius = (mUnreachedRectF.left - mReachedRectF.right) / 2.0f;
//            canvas.drawCircle(start, getHeight() / 2.0f, radius, mCicrlePaint);
            canvas.drawText(mCurrentDrawText!!, mDrawTextStart, mDrawTextEnd, mTextPaint!!)
            //            Log.d("NumberProgressBar", mCurrentDrawText);
//            Log.d("NumberProgressBar", "mDrawTextStart:" + mDrawTextStart);
//            Log.d("NumberProgressBar", "mDrawTextEnd:" + mDrawTextEnd);
//            Log.d("NumberProgressBar", "start:" + start);
        }
    }

    private fun initializePainters() {
        mReachedBarPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        mReachedBarPaint!!.color = mReachedBarColor
        mUnreachedBarPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        mUnreachedBarPaint!!.color = mUnreachedBarColor
        mTextPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        mTextPaint!!.color = textColor
        mTextPaint!!.textSize = mTextSize

//        mCicrlePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        mCicrlePaint.setColor(Color.parseColor("#66ff6666"));
    }

    private fun calculateDrawRectFWithoutProgressText() {
        mReachedRectF.left = paddingLeft.toFloat()
        mReachedRectF.top = height / 2.0f - reachedBarHeight / 2.0f
        mReachedRectF.right =
            (width - paddingLeft - paddingRight) / (max * 1.0f) * progress + paddingLeft
        mReachedRectF.bottom = height / 2.0f + reachedBarHeight / 2.0f
        mUnreachedRectF.left = mReachedRectF.right
        mUnreachedRectF.right = (width - paddingRight).toFloat()
        mUnreachedRectF.top = height / 2.0f + -unreachedBarHeight / 2.0f
        mUnreachedRectF.bottom = height / 2.0f + unreachedBarHeight / 2.0f
    }

    private fun calculateDrawRectF() {
        mCurrentDrawText = String.format("%d", progress * 100 / max)
        mCurrentDrawText = mPrefix + mCurrentDrawText + mSuffix
        mDrawTextWidth = mTextPaint!!.measureText(mCurrentDrawText)
        if (progress == 0) {
            mDrawReachedBar = false
            mDrawTextStart = paddingLeft.toFloat()
        } else {
            mDrawReachedBar = true
            mReachedRectF.left = paddingLeft.toFloat()
            mReachedRectF.top = height / 2.0f - reachedBarHeight / 2.0f
            mReachedRectF.right =
                (width - paddingLeft - paddingRight) / (max * 1.0f) * progress - mOffset + paddingLeft
            mReachedRectF.bottom = height / 2.0f + reachedBarHeight / 2.0f
            mDrawTextStart = mReachedRectF.right + mOffset
        }
        mDrawTextEnd =
            (height / 2.0f - (mTextPaint!!.descent() + mTextPaint!!.ascent()) / 2.0f)
        if (mDrawTextStart + mDrawTextWidth >= width - paddingRight) {
            mDrawTextStart = width - paddingRight - mDrawTextWidth
            mReachedRectF.right = mDrawTextStart - mOffset
        }
        val unreachedBarStart = mDrawTextStart + mDrawTextWidth + mOffset
        if (unreachedBarStart >= width - paddingRight) {
            mDrawUnreachedBar = false
        } else {
            mDrawUnreachedBar = true
            mUnreachedRectF.left = unreachedBarStart
            mUnreachedRectF.right = (width - paddingRight).toFloat()
            mUnreachedRectF.top = height / 2.0f + -unreachedBarHeight / 2.0f
            mUnreachedRectF.bottom = height / 2.0f + unreachedBarHeight / 2.0f
        }
    }

    /**
     * Get progress text size.
     *
     * @return progress text size.
     */
    var progressTextSize: Float
        get() = mTextSize
        set(textSize) {
            mTextSize = textSize
            mTextPaint!!.textSize = mTextSize
            invalidate()
        }
    var unreachedBarColor: Int
        get() = mUnreachedBarColor
        set(barColor) {
            mUnreachedBarColor = barColor
            mUnreachedBarPaint!!.color = mUnreachedBarColor
            invalidate()
        }
    var reachedBarColor: Int
        get() = mReachedBarColor
        set(progressColor) {
            mReachedBarColor = progressColor
            mReachedBarPaint!!.color = mReachedBarColor
            invalidate()
        }
    var progress: Int
        get() = mCurrentProgress
        set(progress) {
            if (progress <= max && progress >= 0) {
                mCurrentProgress = progress
                invalidate()
            }
        }
    var max: Int
        get() = mMaxProgress
        set(maxProgress) {
            if (maxProgress > 0) {
                mMaxProgress = maxProgress
                invalidate()
            }
        }

    fun setProgressTextColor(textColor: Int) {
        this.textColor = textColor
        mTextPaint!!.color = this.textColor
        invalidate()
    }

    var suffix: String?
        get() = mSuffix
        set(suffix) {
            mSuffix = suffix ?: ""
        }
    var prefix: String?
        get() = mPrefix
        set(prefix) {
            mPrefix = prefix ?: ""
        }

    fun incrementProgressBy(by: Int) {
        if (by > 0) {
            progress = progress + by
        }
        if (mListener != null) {
            mListener!!.onProgressChange(progress, max)
        }
    }

    override fun onSaveInstanceState(): Parcelable? {
        val bundle = Bundle()
        bundle.putParcelable(INSTANCE_STATE, super.onSaveInstanceState())
        bundle.putInt(INSTANCE_TEXT_COLOR, textColor)
        bundle.putFloat(INSTANCE_TEXT_SIZE, progressTextSize)
        bundle.putFloat(INSTANCE_REACHED_BAR_HEIGHT, reachedBarHeight)
        bundle.putFloat(INSTANCE_UNREACHED_BAR_HEIGHT, unreachedBarHeight)
        bundle.putInt(INSTANCE_REACHED_BAR_COLOR, reachedBarColor)
        bundle.putInt(INSTANCE_UNREACHED_BAR_COLOR, unreachedBarColor)
        bundle.putInt(INSTANCE_MAX, max)
        bundle.putInt(INSTANCE_PROGRESS, progress)
        bundle.putString(INSTANCE_SUFFIX, suffix)
        bundle.putString(INSTANCE_PREFIX, prefix)
        bundle.putBoolean(INSTANCE_TEXT_VISIBILITY, progressTextVisibility)
        return bundle
    }

    override fun onRestoreInstanceState(state: Parcelable) {
        if (state is Bundle) {
            val bundle = state
            textColor = bundle.getInt(INSTANCE_TEXT_COLOR)
            mTextSize = bundle.getFloat(INSTANCE_TEXT_SIZE)
            reachedBarHeight = bundle.getFloat(INSTANCE_REACHED_BAR_HEIGHT)
            unreachedBarHeight = bundle.getFloat(INSTANCE_UNREACHED_BAR_HEIGHT)
            mReachedBarColor = bundle.getInt(INSTANCE_REACHED_BAR_COLOR)
            mUnreachedBarColor = bundle.getInt(INSTANCE_UNREACHED_BAR_COLOR)
            initializePainters()
            max = bundle.getInt(INSTANCE_MAX)
            progress = bundle.getInt(INSTANCE_PROGRESS)
            prefix = bundle.getString(INSTANCE_PREFIX)
            suffix = bundle.getString(INSTANCE_SUFFIX)
            setProgressTextVisibility(if (bundle.getBoolean(INSTANCE_TEXT_VISIBILITY)) ProgressTextVisibility.VISIBLE else ProgressTextVisibility.INVISIBLE)
            super.onRestoreInstanceState(bundle.getParcelable(INSTANCE_STATE))
            return
        }
        super.onRestoreInstanceState(state)
    }

    fun dp2px(dp: Float): Float {
        val scale = resources.displayMetrics.density
        return dp * scale + 0.5f
    }

    fun sp2px(sp: Float): Float {
        val scale = resources.displayMetrics.scaledDensity
        return sp * scale
    }

    fun setProgressTextVisibility(visibility: ProgressTextVisibility) {
        progressTextVisibility = visibility == ProgressTextVisibility.VISIBLE
        invalidate()
    }

    fun setOnProgressBarListener(listener: OnProgressBarListener?) {
        mListener = listener
    }

    enum class ProgressTextVisibility {
        VISIBLE, INVISIBLE
    }

    interface OnProgressBarListener {
        fun onProgressChange(current: Int, max: Int)
    }

    companion object {
        /**
         * For save and restore instance of progressbar.
         */
        private const val INSTANCE_STATE = "saved_instance"
        private const val INSTANCE_TEXT_COLOR = "text_color"
        private const val INSTANCE_TEXT_SIZE = "text_size"
        private const val INSTANCE_REACHED_BAR_HEIGHT = "reached_bar_height"
        private const val INSTANCE_REACHED_BAR_COLOR = "reached_bar_color"
        private const val INSTANCE_UNREACHED_BAR_HEIGHT = "unreached_bar_height"
        private const val INSTANCE_UNREACHED_BAR_COLOR = "unreached_bar_color"
        private const val INSTANCE_MAX = "max"
        private const val INSTANCE_PROGRESS = "progress"
        private const val INSTANCE_SUFFIX = "suffix"
        private const val INSTANCE_PREFIX = "prefix"
        private const val INSTANCE_TEXT_VISIBILITY = "text_visibility"
        private const val PROGRESS_TEXT_VISIBLE = 0
    }

    init {
        default_reached_bar_height = dp2px(1.5f)
        default_unreached_bar_height = dp2px(1.0f)
        default_text_size = sp2px(10f)
        default_progress_text_offset = dp2px(3.0f)

        //load styled attributes.
        val attributes = context.theme.obtainStyledAttributes(
            attrs,
            R.styleable.UpdateAppNumberProgressBar,
            defStyleAttr,
            0
        )
        mReachedBarColor = attributes.getColor(
            R.styleable.UpdateAppNumberProgressBar_progress_reached_color,
            default_reached_color
        )
        mUnreachedBarColor = attributes.getColor(
            R.styleable.UpdateAppNumberProgressBar_progress_unreached_color,
            default_unreached_color
        )
        textColor = attributes.getColor(
            R.styleable.UpdateAppNumberProgressBar_progress_text_color,
            default_text_color
        )
        mTextSize = attributes.getDimension(
            R.styleable.UpdateAppNumberProgressBar_progress_text_size,
            default_text_size
        )
        reachedBarHeight = attributes.getDimension(
            R.styleable.UpdateAppNumberProgressBar_progress_reached_bar_height,
            default_reached_bar_height
        )
        unreachedBarHeight = attributes.getDimension(
            R.styleable.UpdateAppNumberProgressBar_progress_unreached_bar_height,
            default_unreached_bar_height
        )
        mOffset = attributes.getDimension(
            R.styleable.UpdateAppNumberProgressBar_progress_text_offset,
            default_progress_text_offset
        )
        val textVisible = attributes.getInt(
            R.styleable.UpdateAppNumberProgressBar_progress_text_visibility,
            PROGRESS_TEXT_VISIBLE
        )
        if (textVisible != PROGRESS_TEXT_VISIBLE) {
            progressTextVisibility = false
        }
        progress = attributes.getInt(R.styleable.UpdateAppNumberProgressBar_progress_current, 0)
        max = attributes.getInt(R.styleable.UpdateAppNumberProgressBar_progress_max, 100)
        attributes.recycle()
        initializePainters()
    }
}